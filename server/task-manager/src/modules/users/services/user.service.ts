import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../config/prisma/prisma.service';
import { CreateUserDto } from '../dto/create-user.dto';
import { User } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { UpdateUserDto } from '../dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async createUser(data: CreateUserDto) {
    return this.prisma.user.create({
      data: {
        ...data,
        categories: {
          create: [
            { name: 'Sin categoría' },
            { name: 'Trabajo' },
            { name: 'Viajes' },
            { name: 'Personal' },
            { name: 'Tiempo libre' },
          ],
        },
      },
      include: { categories: true },
    });
  }

  async updateUser(userId: number, data: UpdateUserDto) {
    const updateData: Partial<UpdateUserDto> = { ...data };

    if (data.password) {
      updateData.password = await bcrypt.hash(data.password, 10);
    }

    return this.prisma.user.update({
      where: { id: userId },
      data: updateData,
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { email } });
  }

  async findById(id: number): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { id } });
  }

  remove(id: number) {
    return this.prisma.user.delete({ where: { id } });
  }

  findAll() {
    return this.prisma.user.findMany();
  }
}
