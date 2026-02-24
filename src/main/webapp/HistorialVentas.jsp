<%@ page import="back.ControladoraLogica" %>
<%@ page import="back.Venta" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Historial de Ventas</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
    body {
      background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
      min-height: 100vh; display: flex; flex-direction: column; align-items: center; padding: 40px; color: white;
    }
    .chart-container {
      background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 20px;
      padding: 30px; width: 100%; max-width: 900px; box-shadow: 0 15px 30px rgba(0,0,0,0.5);
    }
    .header-title { font-size: 28px; font-weight: 600; margin-bottom: 20px; color: #00d2ff; text-align: center; }
    .btn-volver {
      margin-top: 30px; padding: 12px 25px; background: rgba(255,255,255,0.1); color: white;
      text-decoration: none; border-radius: 10px; border: 1px solid rgba(255,255,255,0.2); transition: 0.3s;
    }
    .btn-volver:hover { background: rgba(255,255,255,0.2); }
  </style>
</head>
<body>

<%
  ControladoraLogica controladora = new ControladoraLogica();
  ArrayList<Venta> listaVentas = controladora.traerTodasVentas();

  // 3 Arrays: Meses, Plata, y ahora CANTIDAD DE TICKETS
  String[] nombresMes = new String[6];
  double[] totalesMes = new double[6];
  int[] cantidadesMes = new int[6];

  // 1. Calculamos los nombres
  SimpleDateFormat sdfNombre = new SimpleDateFormat("MMM yyyy", new Locale("es", "ES"));
  for(int i = 5; i >= 0; i--) {
    Calendar c = Calendar.getInstance();
    c.add(Calendar.MONTH, -i);
    nombresMes[5-i] = sdfNombre.format(c.getTime()).toUpperCase();
    totalesMes[5-i] = 0.0;
    cantidadesMes[5-i] = 0; // Inicializamos cantidad en cero
  }

  // 2. Acumulamos la plata y contamos los tickets
  for(Venta v : listaVentas) {
    if(v.getFechaVenta() != null) {
      Calendar calVenta = Calendar.getInstance();
      calVenta.setTime(v.getFechaVenta());

      for(int i = 0; i < 6; i++) {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.MONTH, -(5-i));

        if(calVenta.get(Calendar.YEAR) == c.get(Calendar.YEAR) &&
                calVenta.get(Calendar.MONTH) == c.get(Calendar.MONTH)) {
          totalesMes[i] += v.getTotalVenta();
          cantidadesMes[i]++; // Sumamos un ticket a este mes
          break;
        }
      }
    }
  }

  // 3. Convertimos a texto para Javascript
  StringBuilder labelsJS = new StringBuilder("[");
  StringBuilder dataJS = new StringBuilder("[");
  StringBuilder cantidadesJS = new StringBuilder("[");

  for(int i = 0; i < 6; i++) {
    labelsJS.append("'").append(nombresMes[i]).append("'");
    dataJS.append(Math.round(totalesMes[i] * 100.0) / 100.0);
    cantidadesJS.append(cantidadesMes[i]);

    if(i < 5) {
      labelsJS.append(", ");
      dataJS.append(", ");
      cantidadesJS.append(", ");
    }
  }
  labelsJS.append("]");
  dataJS.append("]");
  cantidadesJS.append("]");
%>

<div class="chart-container">
  <h1 class="header-title">📈 Evolución de Ventas (Últimos 6 meses)</h1>
  <canvas id="ventasChart" height="120"></canvas>
</div>

<a href="javascript:history.back()" class="btn-volver">⬅ Volver al Menú</a>

<script>
  // Guardamos las cantidades que calculó Java en una variable de Javascript
  const ticketsPorMes = <%= cantidadesJS.toString() %>;

  const ctx = document.getElementById('ventasChart').getContext('2d');
  const ventasChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: <%= labelsJS.toString() %>,
      datasets: [{
        label: 'Recaudación Histórica',
        data: <%= dataJS.toString() %>,
        backgroundColor: 'rgba(0, 210, 255, 0.2)',
        borderColor: '#00d2ff',
        borderWidth: 3,
        pointBackgroundColor: '#fff',
        pointBorderColor: '#00d2ff',
        pointRadius: 6,
        pointHoverRadius: 9,
        tension: 0.4,
        fill: true
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { labels: { color: 'white', font: { family: 'Poppins', size: 14 } } },

        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          titleFont: { size: 16, family: 'Poppins' },
          bodyFont: { size: 14, family: 'Poppins' },
          padding: 15,
          displayColors: false,
          callbacks: {
            label: function(context) {
              let plataCruda = context.parsed.y;
              let index = context.dataIndex;
              let cantidad = ticketsPorMes[index];

              // MAGIA NUEVA: Formateamos la plata a formato Argentino (1.500.000,00)
              let plataFormateada = plataCruda.toLocaleString('es-AR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

              return [
                '💰 Recaudación: $ ' + plataFormateada,
                '🎟️ Tickets vendidos: ' + cantidad
              ];
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          // MAGIA NUEVA: También formateamos los números de la barrita lateral
          ticks: {
            color: 'rgba(255,255,255,0.7)',
            callback: function(value) {
              return '$ ' + value.toLocaleString('es-AR');
            }
          },
          grid: { color: 'rgba(255,255,255,0.1)' }
        },
        x: {
          ticks: { color: 'rgba(255,255,255,0.7)' },
          grid: { color: 'rgba(255,255,255,0.1)' }
        }
      }
    }
  });
</script>

</body>
</html>