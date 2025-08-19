import {
  ConflictException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../../users/services/user.service';
import { LoginAuthDto } from '../dto/login-auth.dto';
import { Role } from '@prisma/client';
import { UpdateUserDto } from 'src/modules/users/dto/update-user.dto';
import { jwtConstants } from '../const/jwt';
import { PrismaService } from 'src/config/prisma/prisma.service';
import { RegisterAuthDto } from '../dto/register-auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private prisma: PrismaService,
  ) {}

  async register(dto: RegisterAuthDto) {
    const { email, password, name, role } = dto;
    const userExists = await this.usersService.findByEmail(email);
    if (userExists) throw new ConflictException('User already exists');

    const userRole = role ?? Role.USER;

    try {
      const hashed = await bcrypt.hash(password, 10);
      const user = await this.usersService.createUser({
        name,
        email,
        password: hashed,
        role: userRole,
      });

      const tokens = await this.getTokens(user.id, user.role, email);
      await this.updateRefreshTokenHash(user.id, tokens.refreshToken);

      return {
        message: 'User created successfully',
        user: { id: user.id, name: user.name, email: user.email, },
        tokens,
      };
    } catch (error) {
      console.error('Error en register:', error);
      if (error instanceof ConflictException) throw error;
      throw new InternalServerErrorException('Error interno al crear usuario');
    }
  }

  async login(dto: LoginAuthDto) {
    try {
      const user = await this.usersService.findByEmail(dto.email);
      if (!user) throw new UnauthorizedException('Invalid credentials');

      const validPassword = await bcrypt.compare(dto.password, user.password);
      if (!validPassword)
        throw new UnauthorizedException('Invalid credentials');

      const tokens = await this.getTokens(user.id, user.role, user.email);
      await this.updateRefreshTokenHash(user.id, tokens.refreshToken);

      return {
        message: 'Login successful',
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
        },
        tokens,
      };
    } catch (error) {
      console.error('Error en login:', error);
      if (error instanceof UnauthorizedException) throw error;
      throw new InternalServerErrorException('Error interno en login');
    }
  }

  async logout(userId: number) {
    await this.removeRefreshTokenHash(userId);
  }

  async refreshTokens(userId: number, refreshToken: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user || !user.refreshToken) throw new UnauthorizedException();

    const isValid = await bcrypt.compare(refreshToken, user.refreshToken);
    if (!isValid) throw new UnauthorizedException();

    const tokens = await this.getTokens(user.id, user.role, user.email);
    await this.updateRefreshTokenHash(user.id, tokens.refreshToken);
    return tokens;
  }
  async getProfile(userId: number) {
    return this.usersService.findById(userId);
  }

  async updateProfile(userId: number, data: Partial<UpdateUserDto>) {
    return this.usersService.updateUser(userId, data);
  }

  private async getTokens(userId: number, role: Role, email: string) {
    const payload = { id: userId, email, role };

    const accessToken = await this.jwtService.sign(payload, {
      secret: jwtConstants.accessSecret(),
      expiresIn: jwtConstants.accessExpiresIn(),
    });

    const refreshToken = await this.jwtService.sign(
      { sub: userId },
      {
        secret: jwtConstants.refreshSecret(),
        expiresIn: jwtConstants.refreshExpiresIn(),
      },
    );

    return { accessToken, refreshToken };
  }

  private async updateRefreshTokenHash(userId: number, refreshToken: string) {
    const hash = await bcrypt.hash(refreshToken, 10);
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: hash },
    });
  }

  private async removeRefreshTokenHash(userId: number) {
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
  }
}
