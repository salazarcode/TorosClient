using Microsoft.AspNetCore.Components;

namespace TorosClient.src.Pages
{
    public partial class Login
    {
        private LoginRequest loginRequest = new();
        private string errorMessage = string.Empty;
        private bool isLoading = false;

        private async Task HandleLogin()
        {
            try
            {
                isLoading = true;
                errorMessage = string.Empty;

                var result = await AuthService.LoginAsync(loginRequest);
                if (result)
                {
                    NavigationManager.NavigateTo("/admin");
                }
                else
                {
                    errorMessage = "Usuario o contraseña incorrectos";
                }
            }
            catch (Exception ex)
            {
                errorMessage = "Error al intentar iniciar sesión";
            }
            finally
            {
                isLoading = false;
            }
        }
    }
}