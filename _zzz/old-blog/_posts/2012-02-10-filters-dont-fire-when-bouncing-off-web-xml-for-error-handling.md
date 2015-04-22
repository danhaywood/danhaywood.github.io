---
author: danhaywood
comments: true
date: 2012-02-10 22:25:36+00:00
layout: post
slug: filters-dont-fire-when-bouncing-off-web-xml-for-error-handling
title: Filters don't fire when bouncing off web.xml for error handling
wordpress_id: 917
tags:
- java
---

Here's a nice little gotcha for ya!



A fairly common pattern is to use a filter that wraps the (Http)ServletRequest and (Http)ServletResponse in an app-specific wrapper; this can be used to hold user credentials and state etc.  In essence it is:
<!-- more -->
[sourcecode language="java"]
@WebFilter("*")
public class AppRequestResponseFilter implements Filter {
  public void init(FilterConfig fConfig) throws ServletException { }
  public void destroy() {}
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    chain.doFilter(new AppRequest(request), new AppResponse(response));
  }
}
[/sourcecode]




where
[sourcecode language="java"]
public class AppRequest extends HttpServletRequestWrapper {
  public AppRequest(ServletRequest request) {
    super((HttpServletRequest) request);
  }
}
[/sourcecode]



and AppResponse similarly subclasses from HttpServletResponseWrapper.




But let's now look at the following servlet that simply returns an error:

[sourcecode language="java"]
@WebServlet("/sendsAnError")
public class SendsAnErrorServlet extends HttpServlet {
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // safe to downcast here...
    // AppRequest appRequest = (AppRequest)request;
    response.sendError(401);
  }
}
[/sourcecode]



As the comments note, this servlet could downcast HttpServletRequest to AppRequest if it so desired.  Indeed, any filter or servlet could do perform this downcast.  And you can see this in the stacktrace when I put a breakpoint in the servlet:
[![](http://danhaywood.files.wordpress.com/2012/02/sendsanerror.png?w=300)](http://danhaywood.files.wordpress.com/2012/02/sendsanerror.png)




Or could it?  Well, no, not always.  Because in web.xml we have the following entry:
[sourcecode language="xml"]
<error-page>
  <error-code>401</error-code>
  <location>/catchAnError</location>
</error-page>
[/sourcecode]



This instructs the servlet container that if a servlet returns a 401, then to redirect to the resource at the /catchAnError mapping.  In our case, this corresponds to the following servlet:

[sourcecode language="java"]
@WebServlet("/catchAnError")
public class CatchAnErrorServlet extends HttpServlet {
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // ... but not safe to downcast here
    // AppRequest appRequest = (AppRequest)request;
    response.getWriter().println("<p>an error occurred</p>");
  }
}
[/sourcecode]



And so here's the catch: when the servlet container invokes this servlet to handle the error, any filters are NOT called.  And you can see this in the stacktrace when I break in this second servlet; the implementation that is provided is that of the servlet container, not of the filter:
[![](http://danhaywood.files.wordpress.com/2012/02/catchanerror.png?w=300)](http://danhaywood.files.wordpress.com/2012/02/catchanerror.png)



What would happen, do you think, if you were to blindly downcast to AppRequest in this second servlet?  Well, it'd be a ClassCastException, of course, which the servlet container will deal with by just rendering its default error page (for a 401, in this case).  Meanwhile you'll be stuck there wondering why your error handling servlet didn't (seem to) fire.



I guess this is in the servlet spec somewhere, but it's surprising behaviour.  And it had us stumped for a little while.



As ever, comments welcome.


