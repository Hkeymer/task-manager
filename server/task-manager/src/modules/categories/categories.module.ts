import { Module } from '@nestjs/common';
import { CategoriesController } from './controllers/categories.controller';
import { PrismaService } from 'src/config/prisma/prisma.service';
import { CategoriesService } from './services/categories.service';

@Module({
  controllers: [CategoriesController],
  providers: [PrismaService, CategoriesService],
})
export class CategoriesModule {}
