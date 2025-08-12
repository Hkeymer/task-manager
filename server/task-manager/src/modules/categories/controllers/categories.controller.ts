import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  ParseIntPipe,
  UseGuards,
  Req,
} from '@nestjs/common';
import { CategoriesService } from '../services/categories.service';
import { CreateCategoryDto } from '../dto/create-category.dto';
import { UpdateCategoryDto } from '../dto/update-category.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('categories')
@ApiBearerAuth()
@Controller('categories')
@UseGuards(JwtAuthGuard)
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  findAll(@Req() req) {
    return this.categoriesService.findAll(req.user.id);
  }

  @Get(':id')
  findOne(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.findOne(req.user.id, id);
  }

  @Post()
  create(@Req() req, @Body() dto: CreateCategoryDto) {
    return this.categoriesService.create(req.user.id, dto);
  }

  @Put(':id')
  update(
    @Req() req,
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateCategoryDto,
  ) {
    return this.categoriesService.update(req.user.id, id, dto);
  }

  @Delete(':id')
  remove(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.remove(req.user.id, id);
  }
}
