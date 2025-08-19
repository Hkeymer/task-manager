import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
  Req,
  Query,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import { TasksService } from '../services/tasks.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import {
  CreateTaskDto,
  UpdateTaskDto,
  ToggleTaskDto,
  ListTasksQueryDto,
} from '../dto/tasks.dto';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

@ApiTags('tasks')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) { }

  @Post()
  async create(@Req() req, @Body() dto: CreateTaskDto) {
    return this.tasksService.createTask(req.user.id, dto);
  }


  @Get()
  async findAll(@Req() req, @Query() query: ListTasksQueryDto) {
    return this.tasksService.getAllTasks(req.user.id, query);
  }

  @Get('my-tasks')
  async listMyTasks(@Req() req) {
    return this.tasksService.getTasksByUser(req.user.id);
  }

  @Get(':id')
  async findOne(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.tasksService.getTaskById(req.user.id, id);
  }

  @Get('completed')
  async listCompleted(@Req() req) {
    return this.tasksService.getTasksIsCompleted(req.user.id);
  }

  @Get('category/:id')
  async listByCategory(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.tasksService.getTasksByCategory(req.user.id, id);
  }

  @Get('pending')
  async listNotCompleted(@Req() req) {
    return this.tasksService.getTasksIsNotCompleted(req.user.id);
  }

  @Get('favorites')
  async listFavorites(@Req() req) {
    return this.tasksService.getlistFavorites(req.user.id);
  }

  @Patch(':id')
  async update(
    @Req() req,
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTaskDto,
  ) {
    return this.tasksService.updateTask(req.user.id, id, dto);
  }

  @Delete(':id')
  async remove(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.tasksService.deleteTask(req.user.id, id);
  }

  @Patch(':id/completed')
  async toggleIsCompleted(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.tasksService.toggleIsCompleted(req.user.id, id);
  }

  @Patch(':id/favorite')
  async toggleFavorite(@Req() req, @Param('id', ParseIntPipe) id: number) {
    return this.tasksService.toggleFavorite(req.user.id, id);
  }

  @Patch('completed/toggle-all')
  async toggleAllIsCompleted(@Req() req, @Body() dto: ToggleTaskDto) {
    return this.tasksService.toggleAllIsCompleted(req.user.id, dto.completed);
  }
}
