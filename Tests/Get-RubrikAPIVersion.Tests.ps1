Remove-Module -Name 'Rubrik' -ErrorAction 'SilentlyContinue'
Import-Module -Name './Rubrik/Rubrik.psd1' -Force

foreach ( $privateFunctionFilePath in ( Get-ChildItem -Path './Rubrik/Private' | Where-Object extension -eq '.ps1').FullName  ) {
    . $privateFunctionFilePath
}

Describe -Name 'Public/Get-RubrikAPIVersion' -Tag 'Public', 'Get-RubrikAPIVersion' -Fixture {
    #region init
    $global:rubrikConnection = @{
        id      = 'test-id'
        userId  = 'test-userId'
        token   = 'test-token'
        server  = 'test-server'
        header  = @{ 'Authorization' = 'Bearer test-authorization' }
        time    = (Get-Date)
        api     = 'v1'
        version = '4.0.5'
    }
    #endregion

    Context -Name 'Results Filtering' {
        Mock -CommandName Submit-Request -Verifiable -ModuleName 'Rubrik' -MockWith { return 1}
        It -Name 'Should return 1' -Test {
            ( Get-RubrikAPIVersion -Server 'server') |
                Should -BeExactly 1
        }
        It -Name 'Server cannot be null' -Test {
            { Get-RubrikAPIVersion -Server $null } |
                Should -Throw "Cannot bind argument to parameter 'Server' because it is an empty string."
        }
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Submit-Request -ModuleName 'Rubrik' -Exactly 1
    }
}