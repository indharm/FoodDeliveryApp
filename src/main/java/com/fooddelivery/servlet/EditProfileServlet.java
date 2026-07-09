package com.fooddelivery.servlet;

import com.fooddelivery.dao.UserDAO;
import com.fooddelivery.daoimpl.UserDAOImpl;
import com.fooddelivery.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/updateProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 18274917L;
    private UserDAO userDAO = new UserDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");

        user.setUsername(username);
        user.setEmail(email);

        try {
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String fileName = "avatar_" + user.getEmail().split("@")[0] + "_" + System.currentTimeMillis() + ".png";
                String fullSavePath = uploadPath + File.separator + fileName;
                filePart.write(fullSavePath);

                user.setProfileImage("uploads/" + fileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Persist changes to the database
        boolean updated = userDAO.updateUser(user);

        // Keep session in sync with the correct key
        request.getSession().setAttribute("user", user);

        response.sendRedirect("editProfile.jsp" + (updated ? "?status=updated" : "?error=failed"));
    }
}