import { Module } from '@nestjs/common';
import { TasksService } from './services/tasks.service';
import { TasksController } from './controllers/tasks.controller';
import { PrismaService } from 'src/config/prisma/prisma.service';

@Module({
  providers: [TasksService, PrismaService],
  controllers: [TasksController],
})
export class TasksModule {}
