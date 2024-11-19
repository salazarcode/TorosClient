using Microsoft.AspNetCore.Components;
using TorosClient.src.Services;

namespace TorosClient.src.Layout
{
    public partial class AdminLayout
    {
        [Inject]
        private IAuthService AuthService { get; set; }

        [Inject]
        private NavigationManager NavigationManager { get; set; }

        private async Task HandleLogout()
        {
            await AuthService.LogoutAsync();
            NavigationManager.NavigateTo("/");
        }
    }
}