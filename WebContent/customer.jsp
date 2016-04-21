<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>Hello</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" media="screen" href="css/signup.css" >
    <link rel="stylesheet" href="css/bootstrap.min.css">

  </head>
   <body>


<div class="form">
  <h1>Sign Up</h1>
<form class="form-horizontal" role="form" method="GET" action="success.jsp">
  <div class="form-group">
    <label class="control-label col-sm-2">User: </label>
    <div class="col-lg-10">
      <input type="user" class="form-control" name="username" id="username" placeholder="Enter Username">
    </div>
  </div>
 <div class="form-group">
  <label class="control-label roleLabel">Role:</label>
    <div class="roleDrop col-lg-7">
    <select class="form-control" id="role" name="role">
      <option></option>
      <option>Owner</option>
      <option>Customer</option>
      </select>
    </div>
  </div>
  <div class="form-group">
    <label class="control-label col-sm-2" >Age:</label>
    <div class="col-sm-10">
      <input type="username" class="form-control" id="age" name="age" placeholder="Enter Age">
    </div>
  </div>

 <div class="form-group">
  <label class="control-label roleLabel">State:</label>
    <div class="roleDrop col-lg-7">
    <select class="form-control" id="state" name="state">
      <option value="">Select State</option>
      <option value="AL">Alabama</option>
      <option value="AK">Alaska</option>
      <option value="AZ">Arizona</option>
      <option value="AR">Arkansas</option>
      <option value="CA">California</option>
      <option value="CO">Colorado</option>
      <option value="CT">Connecticut</option>
      <option value="DE">Delaware</option>
      <option value="DC">District Of Columbia</option>
      <option value="FL">Florida</option>
      <option value="GA">Georgia</option>
      <option value="HI">Hawaii</option>
      <option value="ID">Idaho</option>
      <option value="IL">Illinois</option>
      <option value="IN">Indiana</option>
      <option value="IA">Iowa</option>
      <option value="KS">Kansas</option>
      <option value="KY">Kentucky</option>
      <option value="LA">Louisiana</option>
      <option value="ME">Maine</option>
      <option value="MD">Maryland</option>
      <option value="MA">Massachusetts</option>
      <option value="MI">Michigan</option>
      <option value="MN">Minnesota</option>
      <option value="MS">Mississippi</option>
      <option value="MO">Missouri</option>
      <option value="MT">Montana</option>
      <option value="NE">Nebraska</option>
      <option value="NV">Nevada</option>
      <option value="NH">New Hampshire</option>
      <option value="NJ">New Jersey</option>
      <option value="NM">New Mexico</option>
      <option value="NY">New York</option>
      <option value="NC">North Carolina</option>
      <option value="ND">North Dakota</option>
      <option value="OH">Ohio</option>
      <option value="OK">Oklahoma</option>
      <option value="OR">Oregon</option>
      <option value="PA">Pennsylvania</option>
      <option value="RI">Rhode Island</option>
      <option value="SC">South Carolina</option>
      <option value="SD">South Dakota</option>
      <option value="TN">Tennessee</option>
      <option value="TX">Texas</option>
      <option value="UT">Utah</option>
      <option value="VT">Vermont</option>
      <option value="VA">Virginia</option>
      <option value="WA">Washington</option>
      <option value="WV">West Virginia</option>
      <option value="WI">Wisconsin</option>
      <option value="WY">Wyoming</option>
    </select>
    </div>
  </div>

  <div class="form-group"> 
    <div class="col-sm-offset-2 col-sm-10">
      <button type="submit" class="btn btn-default">Submit</button>
    </div>
  </div>

</form>
</div>




</body>
</html>



