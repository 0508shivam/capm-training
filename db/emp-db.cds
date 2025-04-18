using { sap, cuid, managed } from '@sap/cds/common';

namespace emp.db;

type EmployeeStatusEnum: Boolean enum {
    ACTIVE = true;
    INACTIVE = false;
}

@readonly
// Entity representing the employee status as a code list
entity EmployeeStatus: sap.common.CodeList {
    key code: EmployeeStatusEnum;
} 

entity Employee : cuid, managed {
    firstName: String;
    lastName: String;
    fullName: String;
    jobTitle: String;
    department: String;
    email: String;
    phone: String;
    location: String;
    isManager: Boolean;
    status: Association to EmployeeStatus;
    peopleLeader: Association to Employee;
    project: Association to Project; //Project
    addresses: Composition of many Address on addresses.employee = $self; //$self = employee
}

entity Address : cuid {
    street: String;
    city: String;
    state: String;
    zipCode: String;
    country: String;
    employee: Association to Employee; //employee
}

entity Project : cuid, managed {
    name: String;
    description: String;
    startDate: Date;
    endDate: Date;
    employees: Association to many Employee on employees.project = $self; // $self = project
}