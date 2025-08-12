import {
  IsBoolean,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  @ApiProperty({ example: 'Task 1' })
  title: string;

  @IsOptional()
  @IsString()
  @ApiProperty({ example: 'Description for task 1' })
  description?: string;

  @IsOptional()
  @IsInt()
  @ApiProperty({ example: 1 })
  categoryId?: number;
}

export class UpdateTaskDto {
  @IsOptional()
  @IsString()
  @ApiProperty({ example: 'Task 1' })
  title?: string;

  @IsOptional()
  @IsString()
  @ApiProperty({ example: 'Description for task 1' })
  description?: string;

  @IsOptional()
  @IsBoolean()
  @ApiProperty({ example: true })
  isCompleted?: boolean;

  @IsOptional()
  @IsInt()
  @ApiProperty({ example: 1 })
  categoryId?: number;
}

export class ToggleTaskDto {
  @IsBoolean()
  @ApiProperty({ example: true })
  completed: boolean;
}

export class ListTasksQueryDto {
  @IsOptional()
  @IsInt()
  @Min(1)
  @ApiProperty({ example: 1 })
  page?: number;

  @IsOptional()
  @IsInt()
  @Min(1)
  @ApiProperty({ example: 10 })
  limit?: number;

  @IsOptional()
  @IsString()
  @ApiProperty({ example: 'Task 1' })
  search?: string;

  @IsOptional()
  @IsInt()
  @ApiProperty({ example: 1 })
  categoryId?: number;

  @IsOptional()
  @IsBoolean()
  @ApiProperty({ example: true })
  onlyFavorites?: boolean;
}
