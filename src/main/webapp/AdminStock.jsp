<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administración de Stock - Control de Almacén</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        /* Reset básico */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        /* Fondo general del sistema */
        body {
            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Contenedor estilo tarjeta de vidrio */
        .menu-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 50px 40px;
            border-radius: 20px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            text-align: center;
            color: white;
        }

        .menu-container h2 {
            margin-bottom: 10px;
            font-weight: 600;
            font-size: 26px;
            letter-spacing: 1px;
        }

        .menu-container p {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 40px;
            font-size: 15px;
        }

        /* --- Estilos de los Botones del Menú --- */
        .menu-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 16px;
            margin-bottom: 20px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            color: white;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* Efecto al pasar el mouse: el botón sube un poquito y brilla */
        .menu-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        /* Botón Agregar (Verde) */
        .btn-agregar {
            background: rgba(46, 204, 113, 0.8);
            border: 1px solid #2ecc71;
        }
        .btn-agregar:hover { background: rgba(46, 204, 113, 1); }

        /* Botón Tabla (Azulito) */
        .btn-tabla {
            background: rgba(52, 152, 219, 0.8);
            border: 1px solid #3498db;
        }
        .btn-tabla:hover { background: rgba(52, 152, 219, 1); }

        /* NUEVO: Botón Informes (Naranja/Dorado Estadístico) */
        .btn-informes {
            background: rgba(243, 156, 18, 0.8);
            border: 1px solid #f39c12;
        }
        .btn-informes:hover { background: rgba(243, 156, 18, 1); }

        /* Botón de Salir/Volver (Gris transparente) */
        .btn-salir {
            margin-top: 30px;
            margin-bottom: 0;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: rgba(255, 255, 255, 0.8);
            font-weight: 500;
        }
        .btn-salir:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        /* NUEVO: Botón Historial (Morado fachero) */
        .btn-historial {
            background: rgba(155, 89, 182, 0.8);
            border: 1px solid #9b59b6;
        }
        .btn-historial:hover { background: rgba(155, 89, 182, 1); }

    </style>
</head>
<body>

<div class="menu-container">
    <h2>Panel de Stock</h2>
    <p>Gestión de inventario y mercadería</p>

    <a href="AdminCargaProducto.jsp" class="menu-btn btn-agregar">
        ➕ Cargar Producto Nuevo
    </a>

    <a href="TablaProductos.jsp" class="menu-btn btn-tabla">
        📋 Ver Tabla de Productos
    </a>

    <a href="informes.jsp" class="menu-btn btn-informes">
        📊 Ver Tablero de Informes
    </a>

    <a href="HistorialVentas.jsp" class="menu-btn btn-historial">
        📈 Ver Evolución de Ventas
    </a>

    <a href="index.jsp" class="menu-btn btn-salir">
        ⬅ Volver al Menú Principal
    </a>
</div>

</body>
</html>