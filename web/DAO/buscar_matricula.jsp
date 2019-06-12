<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%
    
    Connection con = null;
    try{
        Class.forName("com.mysql.jdbc.Driver");  
        System.out.println("Driver conectado <br> <br>");
        con  = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/massagem","root","1234");    //conectando com o banco
        System.out.println("conexão realizada<br> <br>");
        Statement st = con.createStatement();
    }
    catch (Exception e){
        System.out.println("Erro na conexão ao banco de dados, erro = ");
   }
    
    String mat = request.getParameter("mat");
    
    String sql = "SELECT * FROM usuarios WHERE matricula=?";
    PreparedStatement ps = con.prepareStatement(sql);

    ps.setString(1, mat);
    ResultSet rs = ps.executeQuery();
    
    boolean matriculaExistente = false;
    
    //checar se a conta criada já existe (matricula)
    if(rs.next())
    {
        matriculaExistente = true;
    }
    
    response.getWriter().print(matriculaExistente);
    


    
%>