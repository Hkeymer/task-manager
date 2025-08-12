import { Controller, Get, UseGuards } from '@nestjs/common';
import { UsersService } from '../services/user.service';
import { JwtAuthGuard } from 'src/modules/auth/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('users')
export class UserController {
  constructor(private readonly userService: UsersService) {}

  @Get()
  getAllUsers() {
    return this.userService.findAll();
  }
}
