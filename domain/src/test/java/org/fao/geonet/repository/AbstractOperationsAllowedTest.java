package org.fao.geonet.repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.fao.geonet.domain.Group;
import org.fao.geonet.domain.Metadata;
import org.fao.geonet.domain.Operation;
import org.fao.geonet.domain.OperationAllowed;
import org.fao.geonet.domain.ReservedGroup;
import org.fao.geonet.domain.ReservedOperation;
import org.fao.geonet.repository.GroupRepository;
import org.fao.geonet.repository.MetadataRepository;
import org.fao.geonet.repository.OperationAllowedRepository;
import org.fao.geonet.repository.OperationRepository;
import org.junit.Before;
import org.springframework.beans.factory.annotation.Autowired;

public abstract class AbstractOperationsAllowedTest extends AbstractSpringDataTest {

    @Autowired
    MetadataRepository _mdRepo;
    @Autowired
    GroupRepository _groupRepo;
    @Autowired
    OperationRepository _opRepo;
    @Autowired
    protected OperationAllowedRepository _opAllowRepo;
    @PersistenceContext
    private EntityManager _entityManager;

    protected Metadata _md1;
    protected Operation _viewOp;
    protected Group _allGroup;
    protected OperationAllowed _opAllowed1;
    protected Metadata _md2;
    protected Operation _downloadOp;
    protected Group _intranetGroup;
    protected OperationAllowed _opAllowed2;
    protected OperationAllowed _opAllowed3;
    protected OperationAllowed _opAllowed4;
    
    @Before
    public void createEntities() {
        
        this._viewOp = _opRepo.save(ReservedOperation.view.getOperationEntity().setId(-1));
        this._downloadOp = _opRepo.save(ReservedOperation.download.getOperationEntity().setId(-1));
        
        this._allGroup = _groupRepo.save(ReservedGroup.all.getGroupEntityTemplate());
        this._intranetGroup = _groupRepo.save(ReservedGroup.intranet.getGroupEntityTemplate());
    
        Metadata newMd = new Metadata().setUuid("uuid1");
        newMd.getSourceInfo().setOwner(1);
        this._md1 = _mdRepo.save(newMd);

        newMd = new Metadata().setUuid("uuid2");
        newMd.getSourceInfo().setOwner(2);
        this._md2 = _mdRepo.save(newMd);
    
        this._opAllowed1 = _opAllowRepo.save(new OperationAllowed().setGroup(_allGroup).setMetadata(_md1).setOperation(_viewOp));
        this._opAllowed2 = _opAllowRepo.save(new OperationAllowed().setGroup(_intranetGroup).setMetadata(_md2).setOperation(_downloadOp));
        this._opAllowed3 = _opAllowRepo.save(new OperationAllowed().setGroup(_intranetGroup).setMetadata(_md1).setOperation(_downloadOp));
        this._opAllowed4 = _opAllowRepo.save(new OperationAllowed().setGroup(_intranetGroup).setMetadata(_md1).setOperation(_viewOp));
    
        flushAndClear();
    }

    protected void flushAndClear() {
        _opRepo.flush();
        _mdRepo.flush();
        _opAllowRepo.flush();
        _groupRepo.flush();
        _entityManager.flush();
        _entityManager.clear();
    }

}