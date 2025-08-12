import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString, MinLength } from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsEmail()
  @ApiProperty({ example: '0tDlA@example.com' })
  email?: string;

  @IsOptional()
  @IsString()
  @MinLength(3)
  @ApiProperty({ example: 'John Doe' })
  name?: string;

  @IsOptional()
  @IsString()
  @MinLength(6)
  @ApiProperty({ example: '123456' })
  password?: string;
}
