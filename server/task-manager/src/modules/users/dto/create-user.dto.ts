import { Role } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsEnum,
  IsNotEmpty,
  MinLength,
  IsOptional,
  IsString,
} from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty({ example: '0tDlA@example.com' })
  email: string;

  @IsNotEmpty()
  @MinLength(6)
  @IsString()
  @ApiProperty({ example: '123456' })
  password: string;

  @IsNotEmpty()
  @IsString()
  @ApiProperty({ example: 'John Doe' })
  name: string;

  @IsEnum(Role)
  @IsString()
  @IsOptional()
  @ApiProperty({ example: Role.USER })
  role: Role;
}
