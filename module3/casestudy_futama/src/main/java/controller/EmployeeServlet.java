package controller;

import model.*;
import service.IEmployeeService;
import service.impl.EmployeeService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployeeServlet", value = "/Employee")
public class EmployeeServlet extends HttpServlet {
    private IEmployeeService iEmployeeService = new EmployeeService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "create":
                showCreate(request, response);
                break;
            case "edit":
                showEdit(request, response);
                break;
            case "search":
                search(request, response);
                break;
            default:
                listEmployee(request, response);

        }


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "create":
                createEmployee(request, response);
                break;
            case "edit":
                eidtUpdate(request, response);
                break;
            case "delete":
                deleteEmployee(request, response);
                break;
            default:
                listEmployee(request, response);
        }


    }

    public void listEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employee> employeeList = iEmployeeService.findAllEmployee();
        request.setAttribute("list", employeeList);
        request.getRequestDispatcher("employee.jsp").forward(request, response);
    }

    public void showCreate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Division> divisionList = iEmployeeService.selectAllDivision();
        List<EducationDegree> educationDegrees = iEmployeeService.selectAllEducation();
        List<Position> positionList = iEmployeeService.selectAllPosition();

        request.setAttribute("division", divisionList);
        request.setAttribute("education", educationDegrees);
        request.setAttribute("position", positionList);

        request.getRequestDispatcher("createEmployee.jsp").forward(request, response);

    }

    public void createEmployee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String birthday = request.getParameter("birthday");
        String idCard = request.getParameter("idCard");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        double salary = Double.parseDouble(request.getParameter("salary"));

        Position positionid = new Position(Integer.parseInt(request.getParameter("position")), "nhan vien");
        EducationDegree degree = new EducationDegree(Integer.parseInt(request.getParameter("education")), "dai hoc");
        Division division = new Division(Integer.parseInt(request.getParameter("division")), "quan li");
        User userName = new User(request.getParameter("email"), "123123");
        Employee employee = new Employee(employeeId, name, birthday, idCard, salary, phone, email, address, positionid, degree, division, userName);
        iEmployeeService.createEployee(employee);
        response.sendRedirect("Employee");

    }

    //    show edit
    public void showEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        List<Division> divisionList = iEmployeeService.selectAllDivision();
        List<EducationDegree> educationDegrees = iEmployeeService.selectAllEducation();
        List<Position> positionList = iEmployeeService.selectAllPosition();
        Employee employee = iEmployeeService.getEmployeeById(id);

        request.setAttribute("division", divisionList);
        request.setAttribute("education", educationDegrees);
        request.setAttribute("position", positionList);
        request.setAttribute("employee", employee);
        request.getRequestDispatcher("editEmployee.jsp").forward(request, response);

    }

    public void eidtUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        Integer employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String birthday = request.getParameter("birthday");
        String idCard = request.getParameter("idCard");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        double salary = Double.parseDouble(request.getParameter("salary"));

        Position positionid = new Position(Integer.parseInt(request.getParameter("position")), "nhan vien");
        EducationDegree degree = new EducationDegree(Integer.parseInt(request.getParameter("education")), "dai hoc");
        Division division = new Division(Integer.parseInt(request.getParameter("division")), "quan li");
        User userName = new User(request.getParameter("email"), "123123");

//        Employee employee1 = iEmployeeService.getEmployeeById(employeeId);
//        if (employee1==null){
        Employee employee = new Employee(employeeId, name, birthday, idCard, salary, phone, email, address, positionid, degree, division, userName);
        iEmployeeService.update(employee);
        response.sendRedirect("Employee");
//        }else if (employee1!=null){
//            request.setAttribute("name",name);
//            request.setAttribute("email",email);
//            request.setAttribute("birthday",birthday);
//            request.setAttribute("idCard",idCard);
//            request.setAttribute("phone",phone);
//            request.setAttribute("address",address);
//            request.setAttribute("salary",salary);
//            request.setAttribute("positionid",positionid);
//            request.setAttribute("education",degree);
//            request.setAttribute("division",division);
//            request.setAttribute("message","id đã tồn tại");
//            request.getRequestDispatcher("editEmployee.jsp").forward(request,response);
//
//
//
//        }


    }


    //    xóa employeee
    public void deleteEmployee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        iEmployeeService.delele(id);
        response.sendRedirect("Employee");


    }

    //    tìm kiếm
    public void search(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("search");
        List<Employee> employeeList = iEmployeeService.search(name);
        request.setAttribute("list", employeeList);
        request.getRequestDispatcher("employee.jsp").forward(request, response);

    }
}


