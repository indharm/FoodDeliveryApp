<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@700&family=Jost:wght@400;500&display=swap');

    .global-footer {
        background: #0e0b09;
        color: #a99a89;
        padding: 55px 24px 38px;
        margin-top: 80px;
        border-top: 1px solid #2a1f1a;
        text-align: center;
        font-family: 'Jost', sans-serif;
    }
    .footer-brand {
        font-family: 'Cormorant Garamond', serif;
        font-weight: 700;
        font-size: 1.6rem;
        color: #f3e9d8;
        margin-bottom: 10px;
        text-shadow: 0 0 14px rgba(255,180,84,0.35);
    }
    .footer-brand span { color: #ffb454; }
    .footer-tagline {
        font-size: 0.9rem;
        margin-bottom: 24px;
        font-weight: 400;
        font-style: italic;
    }
    .footer-socials {
        display: flex;
        justify-content: center;
        gap: 16px;
        margin-bottom: 26px;
    }
    .footer-socials a {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        border: 1px solid #2a1f1a;
        color: #f3e9d8;
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        transition: all 0.25s ease;
    }
    .footer-socials a:hover {
        border-color: #d4af6a;
        color: #ffb454;
        box-shadow: 0 0 14px rgba(255,180,84,0.3);
    }
    .footer-copy {
        font-size: 0.8rem;
        color: #6e5f52;
        font-weight: 400;
    }
</style>
<footer class="global-footer">
    <div class="footer-brand">Food<span>Hub</span></div>
    <p class="footer-tagline">The city's after-hours menu.</p>
    <div class="footer-socials">
        <a href="#"><i class="fa-brands fa-instagram"></i></a>
        <a href="#"><i class="fa-brands fa-twitter"></i></a>
        <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
    </div>
    <p class="footer-copy">&copy; 2026 FoodHub. All rights reserved.</p>
</footer>