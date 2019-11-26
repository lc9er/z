function WriteHistoryToDisk() {
  $newList = GetAllHistoryAsText $global:history
  Out-File -InputObject $newList -FilePath $cdHistory
}

