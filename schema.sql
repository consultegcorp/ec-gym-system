-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.4.3 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `asistencias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `socio_id` int NOT NULL,
  `fecha_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `socio_id` (`socio_id`),
  CONSTRAINT `asistencias_ibfk_1` FOREIGN KEY (`socio_id`) REFERENCES `socios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cajas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `monto_inicial` decimal(10,2) NOT NULL,
  `monto_final` decimal(10,2) DEFAULT '0.00',
  `total_ventas` decimal(10,2) DEFAULT '0.00',
  `total_gastos` decimal(10,2) DEFAULT '0.00',
  `diferencia` decimal(10,2) DEFAULT '0.00',
  `fecha_apertura` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_cierre` datetime DEFAULT NULL,
  `estado` enum('abierta','cerrada') DEFAULT 'abierta',
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `cajas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `comprobantes_detalle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comprobante_id` int NOT NULL,
  `linea` int NOT NULL DEFAULT '1',
  `codigo` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `unidad` varchar(5) DEFAULT 'NIU' COMMENT 'Cat.03: NIU=unidad, ZZ=servicio',
  `cantidad` decimal(12,3) NOT NULL DEFAULT '1.000',
  `valor_unitario` decimal(12,4) NOT NULL COMMENT 'Sin IGV',
  `precio_unitario` decimal(12,4) NOT NULL COMMENT 'Con IGV',
  `subtotal` decimal(12,2) NOT NULL COMMENT 'cantidad * valor_unitario',
  `igv_linea` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_linea` decimal(12,2) NOT NULL,
  `tipo_afectacion` varchar(2) DEFAULT '10' COMMENT 'Cat.07: 10=Grav., 20=Exo., 30=Inaf., 11/12/13...=Grav.gratuita',
  PRIMARY KEY (`id`),
  KEY `idx_comp` (`comprobante_id`),
  CONSTRAINT `fk_comp_detalle` FOREIGN KEY (`comprobante_id`) REFERENCES `comprobantes_electronicos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `comprobantes_electronicos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `origen_tipo` enum('suscripcion','venta','manual') NOT NULL,
  `origen_id` int DEFAULT NULL,
  `tipo_doc` varchar(2) NOT NULL COMMENT '01,03,07,08',
  `serie` varchar(17) NOT NULL,
  `correlativo` int NOT NULL,
  `clave_acceso` varchar(49) DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `hora_emision` time DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `emisor_ruc` varchar(15) NOT NULL,
  `emisor_razon` varchar(255) NOT NULL,
  `cliente_tipo_doc` varchar(2) NOT NULL,
  `cliente_num_doc` varchar(20) DEFAULT NULL,
  `cliente_razon` varchar(255) NOT NULL,
  `cliente_direccion` varchar(255) DEFAULT NULL,
  `cliente_email` varchar(120) DEFAULT NULL,
  `moneda` varchar(3) DEFAULT 'PEN',
  `gravadas` decimal(12,2) DEFAULT '0.00',
  `inafectas` decimal(12,2) DEFAULT '0.00',
  `exoneradas` decimal(12,2) DEFAULT '0.00',
  `gratuitas` decimal(12,2) DEFAULT '0.00',
  `descuentos` decimal(12,2) DEFAULT '0.00',
  `igv` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `total_letras` varchar(255) DEFAULT NULL,
  `forma_pago` enum('Contado','Credito') DEFAULT 'Contado',
  `metodo_pago` varchar(40) DEFAULT 'efectivo',
  `ref_tipo_doc` varchar(2) DEFAULT NULL,
  `ref_serie` varchar(4) DEFAULT NULL,
  `ref_correlativo` int DEFAULT NULL,
  `motivo_codigo` varchar(2) DEFAULT NULL COMMENT 'Cat.09 (NC) / Cat.10 (ND)',
  `motivo_descripcion` varchar(250) DEFAULT NULL,
  `xml_firmado` mediumtext,
  `sri_authorization_xml` mediumtext,
  `xml_hash` varchar(64) DEFAULT NULL COMMENT 'DigestValue SHA-1 / SHA-256',
  `cdr_zip` mediumblob,
  `cdr_codigo` varchar(10) DEFAULT NULL,
  `cdr_descripcion` varchar(255) DEFAULT NULL,
  `estado_sri` enum('pendiente','recibida','devuelta','autorizado','no_autorizado','anulado','error') DEFAULT 'pendiente',
  `estado_sunat` enum('pendiente','aceptado','rechazado','anulado','observado','enviando','error') DEFAULT 'pendiente',
  `mensaje_error` text,
  `usuario_id` int DEFAULT NULL,
  `creado_en` datetime DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_comprobante` (`tipo_doc`,`serie`,`correlativo`),
  KEY `idx_estado` (`estado_sunat`),
  KEY `idx_fecha` (`fecha_emision`),
  KEY `idx_origen` (`origen_tipo`,`origen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `configuracion` (
  `id` int NOT NULL,
  `nombre_sistema` varchar(100) DEFAULT NULL,
  `ruc` varchar(20) DEFAULT NULL,
  `razon_social` varchar(255) DEFAULT NULL,
  `nombre_comercial` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ubigeo` varchar(6) DEFAULT '150101',
  `departamento` varchar(60) DEFAULT 'LIMA',
  `provincia` varchar(60) DEFAULT 'LIMA',
  `distrito` varchar(60) DEFAULT 'LIMA',
  `urbanizacion` varchar(120) DEFAULT NULL,
  `codigo_pais` varchar(2) DEFAULT 'PE',
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `moneda` varchar(10) DEFAULT '$',
  `sunat_ambiente` enum('beta','produccion') DEFAULT 'beta',
  `sunat_usuario_sol` varchar(50) DEFAULT NULL,
  `sunat_clave_sol` varchar(255) DEFAULT NULL,
  `sunat_certificado` varchar(255) DEFAULT NULL,
  `sunat_cert_clave` varchar(255) DEFAULT NULL,
  `igv_tasa` decimal(5,2) DEFAULT '18.00',
  `incluye_igv` tinyint(1) DEFAULT '1' COMMENT '1 = los precios mostrados YA incluyen IGV',
  `sri_ambiente` enum('1','2') DEFAULT '1' COMMENT '1=Pruebas, 2=Produccion',
  `sri_establecimiento` varchar(3) DEFAULT '001',
  `sri_punto_emision` varchar(3) DEFAULT '001',
  `sri_certificado_p12` varchar(255) DEFAULT NULL,
  `sri_certificado_clave` varchar(255) DEFAULT NULL,
  `iva_tasa` decimal(5,2) DEFAULT '15.00',
  `incluye_iva` tinyint(1) DEFAULT '1' COMMENT '1 = los precios mostrados YA incluyen IVA',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `detalle_ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `venta_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `venta_id` (`venta_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `detalle_ventas_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `detalle_ventas_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `gastos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` date NOT NULL,
  `estado` enum('creado','anulado') DEFAULT 'creado',
  `motivo_anulacion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `medidas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `socio_id` int NOT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  `grasa` decimal(5,2) DEFAULT NULL,
  `cintura` decimal(5,2) DEFAULT NULL,
  `brazo` decimal(5,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `socio_id` (`socio_id`),
  CONSTRAINT `medidas_ibfk_1` FOREIGN KEY (`socio_id`) REFERENCES `socios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `planes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `duracion_dias` int NOT NULL,
  `descripcion` text,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoria_id` int NOT NULL,
  `codigo` varchar(50) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int DEFAULT '0',
  `foto` varchar(255) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  PRIMARY KEY (`id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `rutinas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `socio_id` int NOT NULL,
  `dia1` text,
  `dia2` text,
  `dia3` text,
  `dia4` text,
  `dia5` text,
  `dia6` text,
  `observaciones` text,
  `fecha_asignacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `socio_id` (`socio_id`),
  CONSTRAINT `rutinas_ibfk_1` FOREIGN KEY (`socio_id`) REFERENCES `socios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `socios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `tipo_doc` varchar(1) DEFAULT '1' COMMENT '1=DNI, 6=RUC, 4=CE, 7=PAS, 0=SinDoc',
  `direccion_fiscal` varchar(255) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `whatsapp_api_key` varchar(50) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('activo','inactivo','pendiente') DEFAULT 'activo',
  `foto` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sri_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comprobante_id` int DEFAULT NULL,
  `accion` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'validarComprobante, autorizacionComprobante, etc.',
  `request_xml` mediumtext COLLATE utf8mb4_unicode_ci,
  `response_xml` mediumtext COLLATE utf8mb4_unicode_ci,
  `codigo` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci,
  `creado_en` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_comp_log` (`comprobante_id`),
  KEY `idx_accion` (`accion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sri_series` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_doc` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '01=Factura, 04=Nota de Credito',
  `serie` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Establecimiento + Punto Emision (ej. 001001)',
  `correlativo` int NOT NULL DEFAULT '0',
  `descripcion` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('activo','inactivo') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_tipo_serie` (`tipo_doc`,`serie`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `suscripciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `socio_id` int DEFAULT NULL,
  `plan_id` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` enum('activa','vencida') DEFAULT 'activa',
  `tipo_comprobante` enum('boleta','factura','ninguno') DEFAULT 'boleta',
  `comprobante_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `socio_id` (`socio_id`),
  KEY `plan_id` (`plan_id`),
  CONSTRAINT `suscripciones_ibfk_1` FOREIGN KEY (`socio_id`) REFERENCES `socios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `suscripciones_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `planes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` enum('admin','recepcionista','entrenador') DEFAULT 'recepcionista',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `caja_id` int NOT NULL,
  `socio_id` int DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) NOT NULL DEFAULT '0.00',
  `metodo_pago` enum('efectivo','tarjeta','transferencia') DEFAULT 'efectivo',
  `tipo_comprobante` enum('boleta','factura','ninguno') DEFAULT 'boleta',
  `cliente_tipo_doc` varchar(1) DEFAULT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `cliente_num_doc` varchar(20) DEFAULT NULL,
  `cliente_razon` varchar(255) DEFAULT NULL,
  `cliente_direccion` varchar(255) DEFAULT NULL,
  `comprobante_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `caja_id` (`caja_id`),
  KEY `socio_id` (`socio_id`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`caja_id`) REFERENCES `cajas` (`id`),
  CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`socio_id`) REFERENCES `socios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;