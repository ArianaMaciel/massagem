<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
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
<%@page contentType="application/json charset=UTF-8"%>

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
    
    String dataInicio = request.getParameter("data");
    System.out.println("----------------- " + dataInicio);
    
    String sql = "SELECT * FROM eventos WHERE data_inicio >= ?";
    PreparedStatement ps = con.prepareStatement(sql);
    
    java.util.Date d = new SimpleDateFormat("yyyy-MM-dd").parse(dataInicio);
    java.sql.Date d2 = new Date(d.getTime());
    ps.setDate(1, d2);
    System.out.println(d2);
    //ps.setDate(1, new SimpleDateFormat("yyyy-dd-MM").parse(dataInicio));
    //ps.setDate(1, dataInicio);
    ResultSet rs = ps.executeQuery();
    JSONArray eventos = new JSONArray();
    while(rs.next())
    {
        JSONObject evento = new JSONObject();
        evento.put("id_massagem", rs.getInt(1));
        evento.put("mensagem", rs.getString(2));
        
        Date dt_ini = rs.getDate(3);
        evento.put("data_inicio", dt_ini.toString());
        
        Date dt_fim = rs.getDate(4);
        evento.put("data_fim", dt_fim.toString());
        
        
        evento.put("intervalo", rs.getByte(5));
        evento.put("id_usuario", rs.getInt(6));          
        eventos.add(evento);
    }
    
    System.out.println(">>>>> montou json");
    
    JSONObject json = new JSONObject();
    json.put("eventos", eventos);
    
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8"); 
     System.out.println(">>>>> montou json 2");
    response.getWriter().print(json);

    
%>
