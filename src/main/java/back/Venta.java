package back;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
public class Venta {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int idVenta;
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaVenta;
    private double totalVenta;
    @OneToMany(mappedBy = "venta")
    private List<DetalleVenta> listaDetalles = new ArrayList<>();

    //Constructores
    public Venta() {
    }

    public Venta(Date fechaVenta, int idVenta, List<DetalleVenta> listaDetalles, double totalVenta) {
        this.fechaVenta = fechaVenta;
        this.idVenta = idVenta;
        this.listaDetalles = listaDetalles;
        this.totalVenta = totalVenta;
    }

    // geter y seter
    public Date getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(Date fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public List<DetalleVenta> getListaDetalles() {
        return listaDetalles;
    }

    public void setListaDetalles(List<DetalleVenta> listaDetalles) {
        this.listaDetalles = listaDetalles;
    }

    public double getTotalVenta() {
        return totalVenta;
    }

    public void setTotalVenta(double totalVenta) {
        this.totalVenta = totalVenta;
    }
}
