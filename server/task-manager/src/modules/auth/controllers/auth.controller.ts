import { Body, Controller, Post, UseGuards, Req } from '@nestjs/common';
import { AuthService } from '../services/auth.service';
import { LoginAuthDto } from '../dto/login-auth.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { RegisterAuthDto } from '../dto/register-auth.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() dto: RegisterAuthDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  async login(@Body() dto: LoginAuthDto) {
    return this.authService.login(dto);
  }

  @Post('refresh')
  async refresh(@Body() body: { userId: number; refreshToken: string }) {
    return this.authService.refreshTokens(body.userId, body.refreshToken);
  }

  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @Post('logout')
  async logout(@Req() req) {
    return this.authService.logout(req.user.id);
  }
}
