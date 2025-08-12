import { Module } from '@nestjs/common';
import { UsersService } from './services/user.service';
import { UserController } from './controllers/user.controller';
import { PrismaService } from '../../config/prisma/prisma.service';

@Module({
  controllers: [UserController],
  providers: [UsersService, PrismaService],
  exports: [UsersService],
})
export class UsersModule {}
