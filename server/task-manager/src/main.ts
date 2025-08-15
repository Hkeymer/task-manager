import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import morgan from 'morgan';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.setGlobalPrefix('api/v1');

  const config = new DocumentBuilder()
    .setTitle('Task Manager')
    .setDescription(
      'API RESTful con NestJS y Prisma para gestionar tareas con autenticación JWT, control de roles, filtros por estado/prioridad y documentación con Swagger.',
    )
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  app.enableCors();
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new HttpExceptionFilter());
  app.use(helmet());
  app.use(morgan('dev'));

  const PORT = process.env.PORT || 5000;

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor corriendo en http://192.168.1.3:${PORT}`);
  });
}

bootstrap();
