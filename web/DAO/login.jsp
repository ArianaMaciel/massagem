<%@page import="org.json.simple.JSONObject"%>
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
    String snh = request.getParameter("snh");
    
    String sql = "SELECT id_usuario, nome, senha, tipo FROM usuarios WHERE matricula=?";
    PreparedStatement ps = con.prepareStatement(sql);

    ps.setString(1, mat);
    ResultSet rs = ps.executeQuery();
    
    boolean loginValido = false;
    String mensagem = "";
    
    //checar se a matricula e a senha são válidas   
    if(rs.next())
    {
        String nome = rs.getString("nome");
        String tipo = rs.getString("tipo");
        Integer id_usuario = rs.getInt("id_usuario");
        String senha = rs.getString("senha");
        if (senha.equals(snh))
        {
            JSONObject usuario = new JSONObject();
            usuario.put("id_usuario", id_usuario);
            usuario.put("nome", nome);
            usuario.put("senha", senha);
            usuario.put("matricula", mat);
            usuario.put("tipo", tipo);
            request.getSession().setAttribute("usuario", usuario); 
            
            loginValido = true;
             
        }
        else
        {
            loginValido = false;
            mensagem = "Senha incorreta!";
        }
    }
    else
    {
        mensagem = "Matricula não localizada!";
    }
    
    
    JSONObject json = new JSONObject();
    json.put("loginValido", loginValido);
    json.put("mensagem", mensagem);
    
    
    response.getWriter().print(json);
%>
