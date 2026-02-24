<%@ page import="back.ControladoraLogica" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="back.Producto" %><%--
  Created by IntelliJ IDEA.
  User: Usuario
  Date: 21/2/2026
  Time: 11:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Tabla de Productos</title>
</head>
<body>

<%@ page import="back.ControladoraLogica" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="back.Producto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inventario de Productos - Control de Almacén</title>

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
            height: 100vh;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Contenedor estilo tarjeta de vidrio */
        .dashboard-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 30px;
            border-radius: 20px;
            width: 100%;
            max-width: 1100px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            color: white;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }

        .dashboard-container h2 {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
            letter-spacing: 1px;
            font-size: 24px;
            flex-shrink: 0;
        }

        /* --- EL BUSCADOR PIOLA --- */
        .search-container {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 15px;
            flex-shrink: 0;
        }

        .search-input {
            width: 100%;
            max-width: 300px;
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 14px;
            outline: none;
            transition: all 0.3s;
        }
        .search-input::placeholder { color: rgba(255, 255, 255, 0.6); }
        .search-input:focus {
            border-color: #0074D9;
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 10px rgba(0, 116, 217, 0.3);
        }

        /* --- TABLA Y SCROLL --- */
        .table-wrapper {
            flex-grow: 1;
            overflow-y: auto;
            border-radius: 10px;
            margin-bottom: 20px;
            scrollbar-width: thin;
            scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
        }
        .table-wrapper::-webkit-scrollbar { width: 8px; }
        .table-wrapper::-webkit-scrollbar-thumb {
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.05);
        }

        thead th {
            position: sticky;
            top: 0;
            background: #001f3f;
            z-index: 1;
            padding: 12px 15px;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            color: #80c4ff;
            text-align: left;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        td {
            padding: 10px 15px;
            font-size: 14px;
            color: #f1f1f1;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            vertical-align: middle;
        }

        tbody tr:hover { background: rgba(255, 255, 255, 0.1); }

        /* --- BOTONES DE ACCIÓN --- */
        .btn-action {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            color: white;
            margin-right: 4px;
        }

        .btn-stock { background: #3498db; }
        .btn-stock:hover { background: #2980b9; }

        .btn-modificar { background: #f39c12; }
        .btn-modificar:hover { background: #d68910; }

        .btn-eliminar { background: #e74c3c; }
        .btn-eliminar:hover { background: #c0392b; }

        /* Botón Volver */
        .btn-volver {
            display: inline-block;
            align-self: flex-start;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            flex-shrink: 0;
        }
        .btn-volver:hover { background: rgba(255, 255, 255, 0.2); }

    </style>
</head>
<body>

<div class="dashboard-container">
    <h2>📦 Inventario de Productos</h2>

    <%-- EL BUSCADOR PIOLA --%>
    <div class="search-container">
        <input type="text" id="buscadorTabla" class="search-input" placeholder="🔍 Buscar por marca, tipo...">
    </div>

    <div class="table-wrapper">

        <%-- ATAJAMOS EL MENSAJE DE ÉXITO DE LA SESIÓN (Verde y fantasma) --%>
        <%
            String mensajeExito = (String) session.getAttribute("mensajeExito");
            if (mensajeExito != null) {
        %>
        <div id="cartel-exito" style="background-color: rgba(46, 204, 113, 0.2); border: 1px solid #2ecc71; color: #a9dfbf; padding: 12px; border-radius: 8px; text-align: center; margin-bottom: 20px; font-weight: 500; transition: opacity 0.5s ease;">
            ✅ <%= mensajeExito %>
        </div>
        <script>
            setTimeout(function() {
                let cartel = document.getElementById('cartel-exito');
                if (cartel) {
                    cartel.style.opacity = '0';
                    setTimeout(function() { cartel.style.display = 'none'; }, 500);
                }
            }, 3000);
        </script>
        <%
                session.removeAttribute("mensajeExito");
            }
        %>

        <table>
            <thead>
            <tr>
                <th>Tipo</th>
                <th>Marca</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Acciones</th>
            </tr>
            </thead>

            <tbody>
            <%
                ControladoraLogica controladoraLogica = new ControladoraLogica();
                ArrayList<Producto> listaProd = controladoraLogica.traerTodosProductos();

                if (listaProd != null && !listaProd.isEmpty()) {
                    for (Producto producto : listaProd) {
                        // LA MAGIA DE LA BAJA LÓGICA
                        if (producto.isActivo()) {
            %>
            <tr>
                <td><%=producto.getTipoProd()%></td>
                <td><%=producto.getMarca()%></td>
                <td>$ <%=producto.getPrecio()%></td>

                <td style="<%= producto.getStock() <= 5 ? "color: #ffcccc; font-weight: bold;" : "" %>">
                    <%=producto.getStock()%>
                </td>

                <td>
                    <form action="SvProducto" method="get" style="display:inline;">
                        <input type="hidden" name="accion" value="actuStock">
                        <input type="hidden" name="idActuStock" value="<%=producto.getIdProducto()%>">
                        <button type="submit" class="btn-action btn-stock">+ Stock</button>
                    </form>

                    <form action="SvProducto" method="get" style="display:inline;">
                        <input type="hidden" name="accion" value="modProd">
                        <input type="hidden" name="idProdMod" value="<%=producto.getIdProducto()%>">
                        <button type="submit" class="btn-action btn-modificar">Modificar</button>
                    </form>

                    <form action="SvProducto" method="post" style="display:inline;" onsubmit="return confirm('¿Estás seguro de que querés dar de baja este producto?');">
                        <input type="hidden" name="accion" value="darBajaProd">
                        <input type="hidden" name="idProdBaja" value="<%=producto.getIdProducto()%>">
                        <button type="submit" class="btn-action btn-eliminar">Baja</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: #aaa; padding: 30px;">No hay productos registrados o activos.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <a href="AdminStock.jsp" class="btn-volver">⬅ Volver al Menú</a>
</div>

<%-- MAGIA DEL BUSCADOR PIOLA CON JAVASCRIPT --%>
<script>
    document.getElementById('buscadorTabla').addEventListener('keyup', function() {
        let textoBusqueda = this.value.toLowerCase();
        let filas = document.querySelectorAll('tbody tr');

        filas.forEach(function(fila) {
            // Chequeamos que no sea la fila de "No hay productos"
            if(fila.cells.length > 1) {
                // Agarramos el texto de toda la fila (marca, tipo, precio)
                let contenidoFila = fila.textContent.toLowerCase();
                if(contenidoFila.includes(textoBusqueda)) {
                    fila.style.display = '';
                } else {
                    fila.style.display = 'none';
                }
            }
        });
    });
</script>

</body>
</html>

</body>
</html>


<%--    <%--%>
<%--        ControladoraLogica controladoraLogica = new ControladoraLogica();--%>
<%--        ArrayList<Producto> listaProd = controladoraLogica.traerTodosProductos();--%>
<%--        for (Producto producto : listaProd) {--%>
<%--            if (producto.isActivo()) {--%>
<%--    %>--%>

<%--                <p>Tipo Producto: <%=producto.getTipoProd()%></p>--%>
<%--                <p>Marca Producto: <%=producto.getMarca()%></p>--%>
<%--                <p>Precio: <%=producto.getPrecio()%></p>--%>
<%--                <p>Stock: <%=producto.getStock()%></p>--%>

<%--                <form action="SvProducto" method="post">--%>
<%--                    <input type="hidden" name="accion" value="darBajaProd">--%>
<%--                    <input type="hidden" name="idProdBaja" value="<%=producto.getIdProducto()%>">--%>
<%--                    <button type="submit">Dar de baja</button>--%>
<%--                </form>--%>

<%--                <form action="SvProducto" method="get">--%>
<%--                    <input type="hidden" name="accion" value="modProd">--%>
<%--                    <input type="hidden" name="idProdMod" value="<%=producto.getIdProducto()%>">--%>
<%--                    <button type="submit">Modificar</button>--%>
<%--                </form>--%>

<%--                <form action="SvProducto" method="get">--%>
<%--                    <input type="hidden" name="accion" value="actuStock">--%>
<%--                    <input type="hidden" name="idActuStock" value="<%=producto.getIdProducto()%>">--%>
<%--                    <button>Actualizar Stock</button>--%>
<%--                </form>--%>
<%--        <%}%>--%>

<%--    <%}%>--%>
