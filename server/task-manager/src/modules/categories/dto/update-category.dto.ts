import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class UpdateCategoryDto {
  @IsOptional()
  @IsString()
  @ApiProperty({ example: 'Custom Category' })
  name?: string;
}
