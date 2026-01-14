CREATE DATABASE IF NOT EXISTS noticias;
USE noticias;

-- 1. USUARIOS Y ROLES
CREATE TABLE roles (
    id_rol INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dni VARCHAR(12) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- 2. CATEGORÍAS Y ETIQUETAS
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE etiquetas (
    id_etiqueta INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

-- 3. NOTICIAS
CREATE TABLE noticias (
    id_noticia INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,   
    categoria_id INT NOT NULL,
    img_url VARCHAR(255) NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id_categoria)
);

-- 4. TABLAS QUE GIRA ALREDEDOR DE LA PUBLICACION
CREATE TABLE ediciones (
    id_edicion INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    noticia_id INT NOT NULL,
    rol_id INT NOT NULL,
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (noticia_id) REFERENCES noticias(id_noticia),
    FOREIGN KEY (rol_id) REFERENCES roles(id_rol)
);

CREATE TABLE comentarios (
    id_comentario INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    contenido TEXT NOT NULL,
    usuario_id INT NOT NULL,
    noticia_id INT NOT NULL,
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (noticia_id) REFERENCES noticias(id_noticia)
);

CREATE TABLE noticias_etiquetas (
    noticia_id INT NOT NULL,
    etiqueta_id INT NOT NULL,
    PRIMARY KEY (noticia_id, etiqueta_id), -- Clave primaria compuesta, para los que no saben
    FOREIGN KEY (noticia_id) REFERENCES noticias(id_noticia),
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id_etiqueta)
);

CREATE TABLE likes (
    id_like INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    noticia_id INT NOT NULL,
    fecha_likes DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (noticia_id) REFERENCES noticias(id_noticia)
);

-- CONFIGURACIÓN DE USUARIO
CREATE USER IF NOT EXISTS 'dev_noticias'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON noticias.* TO 'dev_noticias'@'localhost';
FLUSH PRIVILEGES;

-- CONSULTAS DE VERIFICACIÓN
DESCRIBE roles;
DESCRIBE usuarios;
DESCRIBE categorias;
DESCRIBE etiquetas;
DESCRIBE noticias;
DESCRIBE ediciones;
DESCRIBE comentarios;
DESCRIBE noticias_etiquetas;
DESCRIBE likes;

-- Inserta Roles
INSERT INTO roles (nombre) VALUES ('Usuario'), ('Editor'), ('Administrador');

-- Insertar Usuarios
INSERT INTO usuarios (nombre, email, dni, password) VALUES 
('Juan Perez', 'juan@mail.com', '12345678A', 'hash_1'),
('Maria Lopez', 'maria@mail.com', '87654321B', 'hash_2'),
('Admin Gral', 'admin@noticias.com', '11223344C', 'hash_3'),
('Carlos Ruiz', 'carlos@mail.com', '55667788D', 'hash_4');

-- Insertar Categorías
INSERT INTO categorias (nombre) VALUES ('Política'), ('Deportes'), ('Tecnología'), ('Espectáculos');

-- Insertar Etiquetas
INSERT INTO etiquetas (nombre) VALUES ('Urgente'), ('Tendencia'), ('Entrevista'), ('Internacional');

-- Insertar Noticias (4 ejemplos variados)
INSERT INTO noticias (usuario_id, titulo, contenido, categoria_id, img_url) VALUES 
(1, 'Nuevo avance en IA', 'El contenido detallado de la noticia sobre IA...', 3, 'img/ia.jpg'),
(2, 'Final de la Copa', 'Resumen del partido de ayer...', 2, 'img/futbol.jpg'),
(1, 'Elecciones 2024', 'Resultados parciales de las votaciones...', 1, 'img/votos.jpg'),
(4, 'Estreno de Cine', 'La nueva película que rompe récords...', 4, 'img/cine.jpg');

-- Insertar Comentarios
INSERT INTO comentarios (contenido, usuario_id, noticia_id) VALUES 
('Excelente artículo!', 2, 1),
('No estoy de acuerdo con el arbitraje', 1, 2);

-- Relacionar Noticias con Etiquetas
INSERT INTO noticias_etiquetas (noticia_id, etiqueta_id) VALUES (1, 2), (1, 3), (2, 1);

-- Para la tabla Ediciones y Likes, no sabia que datos insertar de forma segura.
-- Hasta aqui llega la tabla. DevJuniorEduardo se despide.
