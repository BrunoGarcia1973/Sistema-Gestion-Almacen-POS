package persistencia;

import back.Rol;

import javax.persistence.*;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

public class RolJpaController {

    private EntityManagerFactory emf = null;

    public RolJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public RolJpaController() {
        emf = Persistence.createEntityManagerFactory("almacen");
    }

    public void create(Rol rol) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(rol);
            em.getTransaction().commit();
        } finally {
            if (em != null) em.close();
        }
    }

    public void edit(Rol rol) throws Exception {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            rol = em.merge(rol);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findRol(rol.getIdRol()) == null) {
                throw new Exception("El registro no existe.");
            }
            throw ex;
        } finally {
            if (em != null) em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Rol rol;
            try {
                rol = em.getReference(Rol.class, id);
                rol.getIdRol();
            } catch (EntityNotFoundException enfe) {
                throw new EntityNotFoundException("El registro con id " + id + " ya no existe.");
            }
            em.remove(rol);
            em.getTransaction().commit();
        } finally {
            if (em != null) em.close();
        }
    }

    public List<Rol> findRolEntities() {
        return findRolEntities(true, -1, -1);
    }

    private List<Rol> findRolEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Rol.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Rol findRol(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Rol.class, id);
        } finally {
            em.close();
        }
    }

}
