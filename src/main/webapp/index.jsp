<%@ page import="back.ControladoraLogica" %>
<%@ page import="back.Usuario" %>
<%@ page import="back.Rol" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Control de Almacén</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        /* Reset básico */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        /* Fondo moderno y fresco (Degradado Azul Marino a Celeste) */
        body {
            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Tarjeta Glassmorphism (Efecto vidrio translúcido) */
        .login-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 20px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            text-align: center;
            color: white;
        }

        .login-card h2 {
            margin-bottom: 5px;
            font-size: 26px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .login-card p.subtitle {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 35px;
        }

        /* Estilos de las cajas de texto */
        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 500;
            color: #e0e0e0;
        }

        .input-group input {
            width: 100%;
            padding: 14px 15px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            font-size: 15px;
            outline: none;
            transition: all 0.3s ease;
        }

        .input-group input:focus {
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(0, 116, 217, 0.4);
        }

        /* Botón de Entrar */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: #0074D9;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s, transform 0.1s;
            margin-top: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-login:hover {
            background: #0056b3;
        }

        .btn-login:active {
            transform: scale(0.98);
        }
    </style>
</head>
<body>

<%--&lt;%&ndash;--%>
<%--&lt;%&ndash;        <%ControladoraLogica controladoraLogica = new ControladoraLogica();&ndash;%&gt;--%>
<%--&lt;%&ndash;        // ==========================================--%>
<%--    // 1. CREACIÓN DE ROLES--%>
<%--    // ==========================================--%>
<%--    --%>
<%--    // Rol Almacén--%>
<%--    Rol rol = new Rol();--%>
<%--    rol.setTipoRol("adminAlmacen");--%>
<%--    rol.setDescripRol("Administrar carga y modificacion de stock en almacen");--%>
<%--    controladoraLogica.crearRol(rol); --%>

<%--    // Rol Común (Cajero)--%>
<%--    Rol rol1 = new Rol();--%>
<%--    rol1.setTipoRol("comun");--%>
<%--    rol1.setDescripRol("Atencion y cobro al cliente, sin carga de stock");--%>
<%--    controladoraLogica.crearRol(rol1);--%>

<%--    // Rol Administrador de Usuarios (EL NUEVO)--%>
<%--    Rol rol2 = new Rol();--%>
<%--    rol2.setTipoRol("adminUser");--%>
<%--    rol2.setDescripRol("Administrar usuarios");--%>
<%--    controladoraLogica.crearRol(rol2);--%>


<%--    // ==========================================--%>
<%--    // 2. CREACIÓN DE USUARIOS INICIALES--%>
<%--    // ==========================================--%>

<%--    // Usuario Almacén--%>
<%--    Usuario usuario = new Usuario();--%>
<%--    usuario.setEmail("bagar206@gmail.com");--%>
<%--    usuario.setNombreUser("admin1");--%>
<%--    String contra1 = "cuarteto";--%>
<%--    String contra1Cifrada = BCrypt.hashpw(contra1, BCrypt.gensalt());--%>
<%--    usuario.setContraseña(contra1Cifrada);--%>
<%--    usuario.setCelular("3516011123");--%>
<%--    usuario.setRol(rol);--%>
<%--    controladoraLogica.crearUser(usuario);--%>

<%--    // Usuario Común (Caja)--%>
<%--    Usuario usuario1 = new Usuario();--%>
<%--    usuario1.setEmail("laurabiagioli@hotamil.com.ar");--%>
<%--    usuario1.setNombreUser("user1");--%>
<%--    String contra2 = "bruno";--%>
<%--    String contra2Cifrada = BCrypt.hashpw(contra2, BCrypt.gensalt());--%>
<%--    usuario1.setContraseña(contra2Cifrada);--%>
<%--    usuario1.setCelular("3512743946");--%>
<%--    usuario1.setRol(rol1);--%>
<%--    controladoraLogica.crearUser(usuario1);--%>

<%--    // Usuario Administrador (El Jefe Maestro)--%>
<%--    Usuario usuario2 = new Usuario();--%>
<%--    usuario2.setEmail("admin_sistema@gmail.com");--%>
<%--    usuario2.setNombreUser("superadmin");--%>
<%--    String contra3 = "admin123"; // Podés cambiarla por la que quieras--%>
<%--    String contra3Cifrada = BCrypt.hashpw(contra3, BCrypt.gensalt());--%>
<%--    usuario2.setContraseña(contra3Cifrada);--%>
<%--    usuario2.setCelular("3510000000"); --%>
<%--    usuario2.setRol(rol2);--%>
<%--    controladoraLogica.crearUser(usuario2);--%>


<%--    %>--%>
<%--    <form action="SvUsuario" method="post">--%>
<%--        <p><label>Nombre Usuario: </label><input type="text" name="nomUser"></p>--%>
<%--        <p><label>Contraseña: </label><input type="text" name="contraUser"></p>--%>
<%--        <input type="hidden" name="accion" value="entrar">--%>
<%--        <button type="submit">Entrar</button>--%>
<%--    </form>--%>

<div class="login-card">
    <h2>Control de Almacén</h2>
    <p class="subtitle">Ingreso al Sistema de Gestión</p>

    <%-- ATAJAMOS EL MENSAJE DE ERROR DEL LOGIN --%>
    <%
        String errorLogin = (String) request.getAttribute("errorLogin");
        if (errorLogin != null) {
    %>
    <div style="background-color: rgba(231, 76, 60, 0.2); border: 1px solid #e74c3c; color: #ffcccc; padding: 12px; border-radius: 8px; text-align: center; margin-bottom: 20px; font-weight: 500;">
        ⚠️ <%= errorLogin %>
    </div>
    <%
        }
    %>

    <form action="SvUsuario" method="post">
        <div class="input-group">
            <label>Usuario</label>
            <input type="text" name="nomUser" placeholder="Ej: admin1" required>
        </div>

        <div class="input-group">
            <label>Contraseña</label>
            <input type="password" name="contraUser" placeholder="••••••••" required>
        </div>

        <input type="hidden" name="accion" value="entrar">
        <button type="submit" class="btn-login">Ingresar</button>
    </form>
</div>

</body>
</html>


