package back;

import javax.persistence.*;

@Entity
public class DetalleVenta {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int idDetalle;
    private int cant;
    private double subTotal;
    @ManyToOne
    private Producto producto;
    @ManyToOne
    private Venta venta;

    // Constructores
    public DetalleVenta() {
    }

    public DetalleVenta(int cant, int idDetalle, Producto producto, double subTotal, Venta venta) {
        this.cant = cant;
        this.idDetalle = idDetalle;
        this.producto = producto;
        this.subTotal = subTotal;
        this.venta = venta;
    }

    // geter y seter

    public int getCant() {
        return cant;
    }

    public void setCant(int cant) {
        this.cant = cant;
    }

    public int getIdDetalle() {
        return idDetalle;
    }

    public void setIdDetalle(int idDetalle) {
        this.idDetalle = idDetalle;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public double getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(double subTotal) {
        this.subTotal = subTotal;
    }

    public Venta getVenta() {
        return venta;
    }

    public void setVenta(Venta venta) {
        this.venta = venta;
    }
}
