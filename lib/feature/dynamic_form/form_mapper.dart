
import 'package:newsee/feature/masters/domain/modal/lov.dart';

class FormMapper {
  final String formName;
  final String formType;
  final String label;
  final List<dynamic>? options;

  FormMapper({
    required this.formName,
    required this.formType,
    required this.label,
    this.options,
  });
}

final List<FormMapper> formMapper = [
  FormMapper(
    formName: "title", 
    formType: "Dropdown", 
    label: "Title", 
    options: ["Mr", "Mrs", "Miss", "Others"]
  ),
  FormMapper(
    formName: "firstName", 
    formType: "AlphaTextField", 
    label: "First Name", 
  ),
  FormMapper(
    formName: "primaryMobileNumber", 
    formType: "IntegerTextField", 
    label: "Primary Mobile Number", 
  ),
  FormMapper(
    formName: "email", 
    formType: "CustomTextField", 
    label: "Email", 
  ),
  FormMapper(
    formName: "city", 
    formType: "SearchableDropdown", 
    label: "City", 
    options: [
      Lov(Header: 'city', optvalue: "1", optDesc: "Chennai", optCode: "1"),
      Lov(Header: 'city', optvalue: "2", optDesc: "Madurai", optCode: "2"),
      Lov(Header: 'city', optvalue: "3", optDesc: "Trichy", optCode: "3")
    ]
  ),
];