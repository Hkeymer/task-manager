import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, MinLength } from 'class-validator';

export class LoginAuthDto {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty({ example: '0tDlA@example.com' })
  email: string;

  @IsNotEmpty()
  @MinLength(6)
  @ApiProperty({ example: '123456' })
  password: string;
}
