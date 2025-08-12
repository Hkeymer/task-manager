import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../../config/prisma/prisma.service';
import { CreateCategoryDto } from '../dto/create-category.dto';
import { UpdateCategoryDto } from '../dto/update-category.dto';

@Injectable()
export class CategoriesService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(userId: number) {
    return this.prisma.category.findMany({
      where: { userId },
      orderBy: { name: 'asc' },
    });
  }

  async findOne(userId: number, categoryId: number) {
    const category = await this.prisma.category.findUnique({
      where: { id: categoryId },
    });
    if (!category) throw new NotFoundException('Category not found');
    if (category.userId !== userId)
      throw new ForbiddenException('Access denied');
    return category;
  }

  async create(userId: number, dto: CreateCategoryDto) {
    return this.prisma.category.create({
      data: {
        name: dto.name,
        userId,
      },
    });
  }

  async update(userId: number, categoryId: number, dto: UpdateCategoryDto) {
    const category = await this.findOne(userId, categoryId);
    return this.prisma.category.update({
      where: { id: category.id },
      data: {
        name: dto.name ?? category.name,
      },
    });
  }

  async remove(userId: number, categoryId: number) {
    const category = await this.findOne(userId, categoryId);
    return this.prisma.category.delete({
      where: { id: category.id },
    });
  }
}
