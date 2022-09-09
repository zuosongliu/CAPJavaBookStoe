using { sap.capire.bookstore as db } from '../db/schema';

// Define Books Service
service BooksService {
    @readonly entity Books as projection   on db.Books { *, category as genre } excluding { category, createdBy, createdAt, modifiedBy, modifiedAt };
    @readonly entity Authors as projection on db.Authors;
}
service AdminService {
    entity Books {
        key ID : Integer;
        title  : String(111);
        descr  : String(1111);
    }
}
// Define Orders Service
service OrdersService {
    @(restrict: [
        { grant: '*', to: 'Administrators' },
        { grant: '*', where: 'createdBy = $user' }
    ])
    entity Orders as projection on db.Orders;
    @(restrict: [
        { grant: '*', to: 'Administrators' },
        { grant: '*', where: 'parent.createdBy = $user' }
    ])    
    entity OrderItems as projection on db.OrderItems;
}

// Reuse Admin Service
annotate AdminService @(requires: 'Administrators');
extend service AdminService with {
    entity Authors as projection on db.Authors;
}
