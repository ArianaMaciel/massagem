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
    
    
    String sql = "INSERT INTO eventos (mensagem, data_inicio, data_fim, intervalo, id_usuario) VALUES (?,?,?,?,?)";
    PreparedStatement ps = con.prepareStatement(sql);
    
    String mensagem = request.getParameter("mensagem");
    Long data_inicio = Long.parseLong(request.getParameter("data_inicio"));
    Long data_fim = Long.parseLong(request.getParameter("data_fim"));
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-dd-MM HH:mm");
    //java.util.Date date = sdf.parse(data_inicio);
    java.sql.Date sqlStartDate = new java.sql.Date(data_inicio);
    
    //java.util.Date date2 = sdf.parse(data_fim);
    java.sql.Date sqlEndDate = new java.sql.Date(data_fim);
    
    ps.setString(1, mensagem);
    ps.setTimestamp(2, new Timestamp(data_inicio));
    ps.setTimestamp(3, new Timestamp(data_fim));
    ps.setInt(4, 0);
    
    
    JSONObject usuario = (JSONObject) request.getSession().getAttribute("usuario"); 
    Integer idUsuario = (Integer) usuario.get("id_usuario");
    ps.setInt(5, idUsuario);
    ps.executeUpdate();
    
    JSONObject json = new JSONObject();
    json.put("mensagem", "Sucesso");
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8"); 
    response.getWriter().print(json);
%>
