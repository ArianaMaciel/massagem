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
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
    Connection con = null;
    try{
        Class.forName("com.mysql.jdbc.Driver");  
        out.println("Driver conectado <br> <br>");
        con  = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/massagem","root","1234");    //conectando com o banco
        out.println("conexão realizada<br> <br>");
        Statement st = con.createStatement();
    }
    catch (Exception e){
        System.out.println("Erro na conexão ao banco de dados, erro = ");
   }
    
    String mat = request.getParameter("mat");
    String snh = request.getParameter("snh");
    String nome = request.getParameter("nome");
    
    String sql = "SELECT matricula, senha FROM usuarios WHERE matricula=?";
    PreparedStatement ps = con.prepareStatement(sql);

    ps.setString(1, mat);
    ResultSet rs = ps.executeQuery();
    
    boolean senhaCorreta = false;
    
    Calendar currenttime =  Calendar.getInstance();
    
    //checar se a conta criada já existe (matricula, senha)
    if(rs.next()){
       String senha = rs.getString("senha");
       String matricula = rs.getString("matricula");
       
       if (senha.equals(snh) && matricula.equals(mat) ){
           senhaCorreta = false;
       }
    }else{
        sql = "INSERT INTO usuarios (matricula, senha, nome, data_criacao, data_alteracao) VALUES (?,?,?,?,?)";
        ps = con.prepareStatement(sql);
        ps.setString(1, mat);
        ps.setString(2, snh);
        ps.setString(3, nome);
        ps.setTimestamp(4, new Timestamp(currenttime.getTime().getTime()));
        ps.setTimestamp(5, new Timestamp(currenttime.getTime().getTime()));
        ps.execute();
        senhaCorreta = true;
     }
        
        response.sendRedirect("../home.html");
    


    
%>