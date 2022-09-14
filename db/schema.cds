namespace sap.capire.bookstore;

using { Currency, cuid, managed,sap.common.CodeList }      from '@sap/cds/common';

entity Books:cuid,managed {
    // Note: we map Books to Products to allow reusing AdminService as is 
    title    : localized String(111);
    descr    : localized String(1111);
    stock    : Integer;
    price    : Decimal(9,2);
    currency : Currency;
    author : Association to Authors;
    category : Association to Categories;
}
entity Categories : CodeList {
    key ID   : Integer;
    parent   : Association to Categories;
    children : Composition of many Categories on children.parent = $self;
}
entity Authors : cuid {
    firstname : String(111);
    lastname  : String(111);
    books     : Association to many Books on books.author = $self;
}

@Capabilities.Updatable: false
entity Orders : cuid, managed {
    items    : Composition of many OrderItems on items.parent = $self;
    total    : Decimal(9,2) @readonly;
    currency : Currency;
}

@Capabilities.Updatable: false
entity OrderItems : cuid {
    parent    : Association to Orders not null;
    book_ID   : UUID;
    amount    : Integer;
    netAmount : Decimal(9,2) @readonly;
}
