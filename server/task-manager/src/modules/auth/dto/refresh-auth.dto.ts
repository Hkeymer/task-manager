import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class RefreshAuthDto {
  @IsNotEmpty()
  @IsNumber()
  @ApiProperty({ example: 1 })
  id: number;

  @IsNotEmpty()
  @IsString()
  @ApiProperty({ example: 'refreshToken' })
  refreshToken: string;
}
