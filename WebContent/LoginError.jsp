
<!DOCTYPE html>
<html>
  <head>
    <title>Hello</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" media="screen" href="css/login.css" >
    <link rel="stylesheet" href="css/bootstrap.min.css">

  </head>
   <body>


 <div class="title">
  <h2>The provided name <%= session.getAttribute("username") %> is not known</h2>
  <h2>Please provide an existing username</h2>
</div>


<div class="form">
  <h1>Login</h1>
<form class="form-horizontal" role="form" method="GET" action="login.jsp">
  <div class="form-group">
    <label class="control-label col-sm-2">User: </label>
    <div class="col-lg-10">
      <input type="username" class="form-control" name="username" id="username" placeholder="Enter Username">
    </div>
  </div>

  <div class="form-group"> 
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" class="btn btn-default">Submit</button>
    </div>
  </div>

</form>
</div>