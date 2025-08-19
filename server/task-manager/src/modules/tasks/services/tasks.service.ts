import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../../config/prisma/prisma.service';
import {
  CreateTaskDto,
  UpdateTaskDto,
  ListTasksQueryDto,
} from '../dto/tasks.dto';

@Injectable()
export class TasksService {
  constructor(private prisma: PrismaService) { }

  private async validateOwnership(userId: number, taskId: number) {
    // Solo traemos el task sin relaciones, suficiente para validar propiedad
    const task = await this.prisma.task.findUnique({
      where: { id: taskId },
    });
    if (!task) throw new NotFoundException('Task not found');
    if (task.userId !== userId)
      throw new ForbiddenException('You do not have permission');
    return task;
  }

  async createTask(userId: number, data: CreateTaskDto) {
    const defaultCategory = await this.prisma.category.findFirst({
      where: { userId, name: 'Sin categoría' },
    });

    if (!defaultCategory) {
      throw new Error(
        'No se encontró la categoría "Sin categoría" para el usuario',
      );
    }

    return this.prisma.task.create({
      data: {
        title: data.title,
        description: data.description,
        isCompleted: false,
        userId,
        categoryId: data.categoryId ?? defaultCategory.id,
      },
    });
  }

  async getTaskById(userId: number, taskId: number) {
    await this.validateOwnership(userId, taskId);
    return this.prisma.task.findUnique({ where: { id: taskId } });
  }

  async getTasksByUser(userId: number) {
    return this.prisma.task.findMany({
      where: { userId },
      include: { category: true, user: true },
    });
  }

  async getTasksByCategory(userId: number, categoryId: number) {
    return this.prisma.task.findMany({
      where: { categoryId, userId },
      include: { category: true, user: true },
    });
  }

  getTasksIsCompleted(userId: number) {
    return this.prisma.task.findMany({
      where: { isCompleted: true, userId },
      include: { category: true, user: true },
    });
  }

  getTasksIsNotCompleted(userId: number) {
    return this.prisma.task.findMany({
      where: { isCompleted: false, userId },
      include: { category: true, user: true },
    });
  }

  async getlistFavorites(userId: number) {
    return this.prisma.task.findMany({
      where: { favoritedBy: { some: { id: userId } } },
      include: { category: true, user: true },
    });
  }


  async getAllTasks(userId: number, query: ListTasksQueryDto) {
    const { page = 1, limit = 10, search, categoryId, onlyFavorites } = query;
    const skip = (page - 1) * limit;

    const where: any = { userId };

    if (categoryId) {
      where.categoryId = categoryId;
    }

    if (onlyFavorites) {
      // Filtra tareas que estén en favoritos del usuario
      where.favoritedBy = { some: { id: userId } };
    }

    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    const [tasks, total] = await Promise.all([
      this.prisma.task.findMany({
        where,
        include: { category: true, user: true },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.task.count({ where }),
    ]);

    return {
      data: tasks,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    };
  }



  async updateTask(userId: number, taskId: number, dto: UpdateTaskDto) {
    await this.validateOwnership(userId, taskId);
    return this.prisma.task.update({
      where: { id: taskId },
      data: dto,
    });
  }

  async deleteTask(userId: number, taskId: number) {
    await this.validateOwnership(userId, taskId);
    return this.prisma.task.delete({ where: { id: taskId } });
  }



  async toggleIsCompleted(userId: number, taskId: number) {
    const task = await this.validateOwnership(userId, taskId);
    return this.prisma.task.update({
      where: { id: taskId },
      data: { isCompleted: !task.isCompleted },
      select: { isCompleted: true },
    });
  }

  async toggleFavorite(userId: number, taskId: number) {
    const task = await this.prisma.task.findUnique({
      where: { id: taskId },
      include: { favoritedBy: true },
    });
    if (!task) throw new NotFoundException('Task not found');

    const isFav = task.favoritedBy.some((u) => u.id === userId);

    if (isFav) {
      await this.prisma.task.update({
        where: { id: taskId },
        data: { favoritedBy: { disconnect: { id: userId } } },
      });
      return { favorite: false };
    } else {
      await this.prisma.task.update({
        where: { id: taskId },
        data: { favoritedBy: { connect: { id: userId } } },
      });
      return { favorite: true };
    }
  }

  async toggleAllIsCompleted(userId: number, completed: boolean) {
    return this.prisma.task.updateMany({
      where: { userId },
      data: { isCompleted: completed },
    });
  }
}
