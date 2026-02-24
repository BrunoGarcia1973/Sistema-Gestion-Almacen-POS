<%@ page import="java.util.ArrayList" %>
<%@ page import="back.Producto" %>
<%@ page import="back.ControladoraLogica" %>
<%@ page import="back.DetalleVenta" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Caja Registradora - Control de Almacén</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* Reset básico */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);
            height: 100vh;
            overflow: hidden; /* Que no haya scroll en toda la página */
            display: flex;
            padding: 20px;
            gap: 20px;
            color: white;
        }

        /* --- PANTALLA DIVIDIDA --- */
        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* --- IZQUIERDA: CATÁLOGO DE PRODUCTOS (60%) --- */
        .catalog-section {
            flex: 6;
            padding: 20px;
        }

        .catalog-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-input {
            width: 300px;
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.15);
            color: white;
            outline: none;
            transition: all 0.3s;
        }
        .search-input:focus { border-color: #0074D9; box-shadow: 0 0 10px rgba(0, 116, 217, 0.3); }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 15px;
            overflow-y: auto;
            height: calc(100vh - 140px);
            padding-right: 10px;
            /* Estilo del scroll */
            scrollbar-width: thin;
            scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
        }

        /* Tarjetita del Producto */
        .product-card {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.2s;
        }
        .product-card:hover { transform: translateY(-3px); background: rgba(0, 0, 0, 0.3); }
        .product-title { font-size: 16px; font-weight: 600; margin-bottom: 5px; color: #80c4ff; line-height: 1.2;}
        .product-price { font-size: 20px; font-weight: 700; margin: 10px 0; color: #2ecc71; }

        .add-form { display: flex; gap: 5px; margin-top: 10px; }
        .add-form input[type="number"] {
            width: 60px;
            padding: 8px;
            border-radius: 6px;
            border: none;
            text-align: center;
            font-weight: bold;
        }
        .btn-add {
            flex-grow: 1;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-add:hover { background: #2980b9; }

        /* --- DERECHA: TICKET / CARRITO (40%) --- */
        .cart-section {
            flex: 4;
            display: flex;
            flex-direction: column;
            background: rgba(0, 0, 0, 0.15); /* Un toque más oscuro */
        }

        .cart-header { padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); text-align: center; }
        .cart-header h2 { font-size: 22px; }

        .cart-items {
            flex-grow: 1;
            overflow-y: auto;
            padding: 20px;
            scrollbar-width: thin;
            scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
        }

        /* Renglón del ticket */
        .cart-item {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #3498db;
        }
        .cart-item-info { flex-grow: 1; }
        .cart-item-title { font-weight: 600; font-size: 14px; }
        .cart-item-price { font-size: 12px; color: #aaa; }

        .cart-item-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .cart-item-subtotal { font-weight: 700; font-size: 16px; color: #2ecc71; min-width: 70px; text-align: right; }

        /* Botoncitos de accion del carrito */
        .btn-icon {
            width: 28px;
            height: 28px;
            border-radius: 4px;
            border: none;
            font-weight: bold;
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }
        .btn-minus { background: #f39c12; }
        .btn-minus:hover { background: #d68910; }
        .btn-delete { background: #e74c3c; }
        .btn-delete:hover { background: #c0392b; }

        /* --- TOTAL Y COBRAR (Abajo a la derecha) --- */
        .cart-footer {
            padding: 20px;
            background: rgba(0, 0, 0, 0.3);
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        .total-display {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        .btn-cobrar {
            width: 100%;
            padding: 15px;
            background: #2ecc71;
            color: white;
            font-size: 20px;
            font-weight: 700;
            text-transform: uppercase;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.3s, transform 0.1s;
        }
        .btn-cobrar:hover { background: #27ae60; }
        .btn-cobrar:active { transform: scale(0.98); }

        /* Alerta de Error */
        .alert-error {
            background-color: rgba(231, 76, 60, 0.8);
            color: white;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
            margin-bottom: 15px;
        }

    </style>
</head>
<body>

<div class="glass-panel catalog-section">

    <div class="catalog-header">
        <h2>🛒 Mostrador</h2>
        <input type="text" id="buscadorProductos" class="search-input" placeholder="🔍 Buscar producto...">
    </div>

    <%-- ATAJAMOS EL MENSAJE DE ERROR --%>
    <%
        String mensajeError = (String) request.getAttribute("mensajeError");
        if (mensajeError != null) {
    %>
    <div class="alert-error">⚠️ <%= mensajeError %></div>
    <% } %>

    <div class="products-grid">
        <%
            ControladoraLogica controladoraLogica = new ControladoraLogica();
            ArrayList<Producto> listaProductos = controladoraLogica.traerTodosProductos();

            if (listaProductos != null) {
                for (Producto producto : listaProductos) {
                    if (producto.isActivo()) {
        %>

        <div class="product-card">
            <div>
                <div class="product-title"><%=producto.getMarca()%> - <%=producto.getTipoProd()%></div>
                <div class="cart-item-price">Stock: <span style="<%= producto.getStock() <= 5 ? "color: #ffcccc;" : "" %>"><%=producto.getStock()%></span></div>
                <div class="product-price">$ <%=producto.getPrecio()%></div>
            </div>

            <form action="SvCarro" method="post" class="add-form">
                <input type="number" name="cant" value="1" min="1" required>
                <input type="hidden" name="accion" value="agregar">
                <input type="hidden" name="idProdAgregar" value="<%=producto.getIdProducto()%>">
                <button type="submit" class="btn-add">Agregar</button>
            </form>
        </div>

        <%          }
        }
        }
        %>
    </div>

    <a href="index.jsp" style="color: rgba(255,255,255,0.6); text-decoration: none; margin-top: 15px; font-size: 14px;">⬅ Volver al Menú Principal</a>
</div>

<div class="glass-panel cart-section">

    <div class="cart-header">
        <h2>🧾 Ticket de Venta</h2>
    </div>

    <div class="cart-items">
        <%
            double total = 0;
            ArrayList<DetalleVenta> listaDetalle = (ArrayList<DetalleVenta>) request.getSession().getAttribute("carrito");

            if (listaDetalle == null || listaDetalle.isEmpty()) {
        %>
        <div style="text-align: center; color: rgba(255,255,255,0.5); margin-top: 50px;">
            <p style="font-size: 40px; margin-bottom: 10px;">🛒</p>
            <p>El carrito está vacío</p>
            <p style="font-size: 12px;">Agregá productos desde el panel izquierdo.</p>
        </div>
        <%
        } else {
            for (DetalleVenta detalleVenta : listaDetalle) {
                total += detalleVenta.getSubTotal();
        %>

        <div class="cart-item">
            <div class="cart-item-info">
                <div class="cart-item-title"><%=detalleVenta.getCant()%>x <%=detalleVenta.getProducto().getMarca()%></div>
                <div class="cart-item-price"><%=detalleVenta.getProducto().getTipoProd()%> ($<%=detalleVenta.getProducto().getPrecio()%>)</div>
            </div>

            <div class="cart-item-actions">
                <div class="cart-item-subtotal">$ <%=detalleVenta.getSubTotal()%></div>

                <form action="SvCarro" method="post" style="margin:0;">
                    <input type="hidden" name="accion" value="descontarCarro">
                    <input type="hidden" name="idDetalleDesco" value="<%=detalleVenta.getProducto().getIdProducto()%>">
                    <button type="submit" class="btn-icon btn-minus" title="Restar uno">-</button>
                </form>

                <form action="SvCarro" method="post" style="margin:0;">
                    <input type="hidden" name="accion" value="eliminarCarro">
                    <input type="hidden" name="idDetalleEli" value="<%=detalleVenta.getProducto().getIdProducto()%>">
                    <button type="submit" class="btn-icon btn-delete" title="Eliminar renglón">✕</button>
                </form>
            </div>
        </div>

        <%
                }
            }
        %>
    </div>

    <div class="cart-footer">
        <%
            // Preparamos el "traje argentino" para los números
            NumberFormat formatoPlata = NumberFormat.getInstance(new Locale("es", "AR"));
            formatoPlata.setMinimumFractionDigits(2);
            formatoPlata.setMaximumFractionDigits(2);
        %>
        <div class="total-display">
            <span>TOTAL:</span>
            <span>$ <%= formatoPlata.format(total) %></span>
        </div>
        <div style="display: flex; gap: 10px;">
            <form action="SvCarro" method="post" style="flex: 1; margin: 0; display: flex;">
                <input type="hidden" name="accion" value="cobrar">
                <button type="submit" class="btn-cobrar"
                        style="background: #27ae60; font-size: 16px; width: 100%; <%= total == 0 ? "opacity: 0.5; cursor: not-allowed;" : "cursor: pointer;" %>"
                        <%= total == 0 ? "disabled" : "" %>>
                    💵 EFECTIVO
                </button>
            </form>

            <button type="button" class="btn-cobrar"
                    style="background: #009ee3; flex: 1; font-size: 16px; <%= total == 0 ? "opacity: 0.5; cursor: not-allowed;" : "cursor: pointer;" %>"
                    onclick="<%= total == 0 ? "return false;" : "abrirModalMP()" %>"
                    <%= total == 0 ? "disabled" : "" %>>
                📱 M. PAGO
            </button>
        </div>
    </div>
</div>
<div id="modalMP" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:9999; justify-content:center; align-items:center; backdrop-filter: blur(5px);">

    <div style="background:white; padding:30px; border-radius:20px; text-align:center; color:black; width: 450px; max-width: 90%; max-height: 90vh; overflow-y: auto; box-shadow: 0 15px 40px rgba(0,0,0,0.5);">

<%--        <img src="https://www.redciteco.org/images/rc23/articulos/mercadoPago200.jpg" width="60" style="margin-bottom:10px;">--%>
<%--        <h2 style="margin:0; color:#009ee3; font-size: 24px;">Mercado Pago</h2>--%>
        <p style="margin: 5px 0; color: #666; font-size: 15px;">Pedile al cliente que escanee el QR e ingrese este monto:</p>

    <%
        double totalConRecargoMP = total * 1.0411;
    %>

    <h1 style="font-size:45px; margin:15px 0; color: #333; letter-spacing: -1px;">
        $ <%= formatoPlata.format(totalConRecargoMP) %>
    </h1>

    <p style="font-size: 14px; color: #e74c3c; font-weight: bold; margin-top: -10px; margin-bottom: 15px;">
        (Incluye comisión de Mercado Pago del 3,95%)
    </p>

        <div style="background: #f1f2f6; padding: 15px; border-radius: 15px; display: inline-block; margin-bottom: 10px;">
            <img src="img/qr-mp.jpeg" width="250" alt="QR MP" style="border-radius: 10px; display: block; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        </div>

        <p style="font-size:15px; color:#888; margin-top: 5px;">Alias: <strong style="color: #333; font-size: 18px;">brunogarcia27</strong></p>

        <div style="display:flex; gap:15px; margin-top:20px;">
            <button type="button" onclick="cerrarModalMP()" style="padding:15px; flex:1; background:#e74c3c; color:white; border:none; border-radius:10px; cursor:pointer; font-weight: bold; font-size: 18px; transition: 0.2s;">❌ Cancelar</button>

            <form action="SvCarro" method="post" style="flex:1; margin:0;">
                <input type="hidden" name="accion" value="cobrar">
                <input type="hidden" name="metodoPago" value="MP">
                <button type="submit" style="width:100%; padding:15px; background:#2ecc71; color:white; border:none; border-radius:10px; cursor:pointer; font-weight:bold; font-size: 18px; transition: 0.2s;">✅ Imprimir</button>
            </form>
        </div>
    </div>
</div>

<script>
    function abrirModalMP() {
        document.getElementById('modalMP').style.display = 'flex';
    }

    function cerrarModalMP() {
        document.getElementById('modalMP').style.display = 'none';
    }

    // ... Acá abajo dejá el script del buscador que ya tenías ...
    <%-- MAGIA JAVASCRIPT PARA EL BUSCADOR --%>
    document.getElementById('buscadorProductos').addEventListener('keyup', function() {
        let textoBusqueda = this.value.toLowerCase();
        let productos = document.querySelectorAll('.product-card');

        productos.forEach(function(producto) {
            // Busca en el texto de la tarjeta (Marca y Tipo)
            let contenido = producto.textContent.toLowerCase();
            if(contenido.includes(textoBusqueda)) {
                producto.style.display = 'flex';
            } else {
                producto.style.display = 'none';
            }
        });
    });
</script>

</body>
</html>
<%--    <%--%>
<%--        double total = 0;--%>
<%--        ControladoraLogica controladoraLogica = new ControladoraLogica();--%>
<%--        ArrayList<Producto> listaProductos = controladoraLogica.traerTodosProductos();--%>
<%--        for (Producto producto : listaProductos) {--%>
<%--            if (producto.isActivo()) {--%>



<%--    %>--%>
<%--        <form action="SvCarro" method="post">--%>
<%--            <p>Tipo Producto: <%=producto.getTipoProd()%></p>--%>
<%--            <p>Marca Producto: <%=producto.getMarca()%></p>--%>
<%--            <p>Precio: <%=producto.getPrecio()%></p>--%>
<%--            <p>Stock: <%=producto.getStock()%></p>--%>
<%--            <label>Cantidad: </label><input type="text" name="cant">--%>
<%--            <input type="hidden" name="accion" value="agregar">--%>
<%--            <input type="hidden" name="idProdAgregar" value="<%=producto.getIdProducto()%>">--%>
<%--            <button type="submit">Agregar</button>--%>
<%--        </form>--%>
<%--        <%}%>--%>
<%--    <%}%>--%>

<%--    <%--%>
<%--        ArrayList<DetalleVenta> listaDetalle = (ArrayList<DetalleVenta>) request.getSession().getAttribute("carrito");--%>
<%--        if (listaDetalle == null || listaDetalle.isEmpty()) {--%>
<%--    %>--%>
<%--            <p>No hay productos en el carrito</p>--%>
<%--    <%}--%>
<%--        else {--%>


<%--        for (DetalleVenta detalleVenta : listaDetalle) {--%>
<%--    %>--%>
<%--        <form action="SvCarro" method="post">--%>
<%--            <p>Tipo Producto: <%=detalleVenta.getProducto().getTipoProd()%></p>--%>
<%--            <p>Marca Producto: <%=detalleVenta.getProducto().getMarca()%></p>--%>
<%--            <p>Precio unitario: <%=detalleVenta.getProducto().getPrecio()%></p>--%>
<%--            <p>Cantidad: <%=detalleVenta.getCant()%></p>--%>
<%--            <p>Sub Total: <%=detalleVenta.getSubTotal()%></p>--%>
<%--            <input type="hidden" name="accion" value="eliminarCarro">--%>
<%--            <input type="hidden" name="idDetalleEli" value="<%=detalleVenta.getProducto().getIdProducto()%>">--%>
<%--            <button type="submit">Eliminar Del Carro</button>--%>
<%--        </form>--%>

<%--        <form action="SvCarro" method="post">--%>
<%--            <input type="hidden" name="accion" value="descontarCarro">--%>
<%--            <input type="hidden" name="idDetalleDesco" value="<%=detalleVenta.getProducto().getIdProducto()%>">--%>
<%--            <button type="submit">Descontar</button>--%>
<%--        </form>--%>
<%--    <%--%>
<%--        total = total + detalleVenta.getSubTotal();--%>
<%--    %>--%>
<%--    <%}%>--%>
<%--<% }%>--%>
<%--        <p>Total: <%=total%></p>--%>
<%--    <form action="SvCarro" method="post">--%>
<%--        <input type="hidden" name="accion" value="cobrar">--%>
<%--        <button type="submit">Cobrar</button>--%>
<%--    </form>--%>
