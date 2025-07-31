# API de Autenticación - TestApi

Esta es una API de autenticación completa construida con Ruby on Rails y arquitectura hexagonal usando Trailblazer.

## Características

- ✅ Registro de usuarios
- ✅ Login con JWT
- ✅ Recuperación de contraseña
- ✅ Validación de tokens de restablecimiento
- ✅ Restablecimiento de contraseña
- ✅ Obtener información del usuario autenticado
- ✅ Validaciones robustas
- ✅ Manejo de errores
- ✅ Arquitectura hexagonal con Trailblazer
- ✅ API versionada

## Endpoints Disponibles

### Base URL
```
http://localhost:3000/api/v1/auth
```

### 1. POST /api/v1/auth/login
Autentica un usuario existente.

**Request:**
```json
{
  "email": "admin@barberia.com",
  "password": "123456"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "admin@barberia.com",
      "name": "Administrador",
      "role": "admin",
      "avatar": null,
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    },
    "accessToken": "jwt_access_token",
    "refreshToken": "jwt_refresh_token"
  },
  "message": "Login exitoso"
}
```

**Response (422):**
```json
{
  "success": false,
  "errors": {
    "email": ["no puede estar en blanco"],
    "password": ["no puede estar en blanco"]
  },
  "message": "Error en el login"
}
```

### 2. POST /api/v1/auth/register
Registra un nuevo usuario.

**Request:**
```json
{
  "name": "Juan Pérez",
  "email": "juan@example.com",
  "password": "123456",
  "confirm_password": "123456",
  "phone": "+1234567890",
  "role": "customer"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "juan@example.com",
      "name": "Juan Pérez",
      "role": "customer",
      "avatar": null,
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    },
    "accessToken": "jwt_access_token",
    "refreshToken": "jwt_refresh_token"
  },
  "message": "Registro exitoso"
}
```

**Response (422):**
```json
{
  "success": false,
  "errors": {
    "email": ["ya está en uso"]
  },
  "message": "Error en el registro"
}
```

### 3. POST /api/v1/auth/forgot-password
Solicita un token para restablecer la contraseña.

**Request:**
```json
{
  "email": "admin@barberia.com"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Correo de recuperación enviado exitosamente"
}
```

### 4. POST /api/v1/auth/validate-reset-token
Valida un token de restablecimiento de contraseña.

**Request:**
```json
{
  "token": "reset_token_here"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Token válido"
}
```

**Response (422):**
```json
{
  "success": false,
  "errors": {
    "token": ["es inválido o ha expirado"]
  },
  "message": "Token inválido o expirado"
}
```

### 5. POST /api/v1/auth/reset-password
Restablece la contraseña usando un token válido.

**Request:**
```json
{
  "token": "reset_token_here",
  "password": "nueva_contraseña"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Contraseña restablecida exitosamente"
}
```

### 6. GET /api/v1/auth/me
Obtiene la información del usuario autenticado.

**Headers:**
```
Authorization: Bearer jwt_access_token
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "admin@barberia.com",
    "name": "Administrador",
    "role": "admin",
    "avatar": null,
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
}
```

**Response (401):**
```json
{
  "success": false,
  "message": "Token de autorización requerido"
}
```

## Usuarios de Prueba

La aplicación viene con dos usuarios pre-creados:

1. **Admin User:**
   - Email: `admin@barberia.com`
   - Password: `password123`
   - Role: `admin`

2. **Regular User:**
   - Email: `maria@barberia.com`
   - Password: `Password123!`
   - Role: `user`

## Estructura del Proyecto

```
app/
├── concepts/auth/          # Arquitectura hexagonal con Trailblazer
│   ├── operation/          # Lógica de negocio
│   ├── contract/           # Validaciones
│   └── representer/        # Serializadores
├── controllers/            # Controladores Rails
├── models/                 # Modelos ActiveRecord
└── lib/jwt_service/        # Servicio JWT
```

## Comandos Útiles

```bash
# Iniciar el servidor
wsl rails server -b 0.0.0.0 -p 3000

# Ejecutar migraciones
wsl rails db:migrate

# Cargar datos de prueba
wsl rails db:seed

# Consola Rails
wsl rails console

# Ejecutar tests
wsl rails test
```

## Tecnologías Utilizadas

- **Ruby on Rails 8.0.2** - Framework web
- **Trailblazer 2.1** - Arquitectura hexagonal
- **JWT 2.7** - Autenticación con tokens
- **BCrypt** - Encriptación de contraseñas
- **SQLite** - Base de datos
- **Puma** - Servidor web

## Notas de Seguridad

- Las contraseñas se almacenan encriptadas con BCrypt
- Los tokens JWT tienen expiración (1 hora para access, 7 días para refresh)
- Los tokens de reset de contraseña expiran en 2 horas
- Validaciones robustas en todos los endpoints
- Headers de autorización requeridos para endpoints protegidos

## Testing

Puedes probar la API usando herramientas como Postman, curl o cualquier cliente HTTP. La API está disponible en `http://localhost:3000`.

Ejemplo con curl:
```bash
# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@barberia.com","password":"password123"}'

# Get user info (reemplaza TOKEN con el access token obtenido)
curl -X GET http://localhost:3000/api/v1/auth/me \
  -H "Authorization: Bearer TOKEN"
```