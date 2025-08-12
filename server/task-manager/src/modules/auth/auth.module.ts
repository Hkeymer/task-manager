import { Module } from '@nestjs/common';
import { AuthService } from './services/auth.service';
import { AuthController } from './controllers/auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { JwtStrategy } from './jwt/jwt.strategy';
import { UsersModule } from '../users/users.module';
import { PassportModule } from '@nestjs/passport';
import { jwtConstants } from './const/jwt';
import { PrismaService } from 'src/config/prisma/prisma.service';

@Module({
  imports: [
    UsersModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.register({
      secret: jwtConstants.accessSecret,
      signOptions: { expiresIn: jwtConstants.accessExpiresIn },
    }),
  ],
  providers: [AuthService, JwtStrategy, PrismaService],
  controllers: [AuthController],
})
export class AuthModule {}
