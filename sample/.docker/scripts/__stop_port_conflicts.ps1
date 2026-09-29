# このサンプルが使うポート(80/443/1080/8080)を使用していて、かつ
# プロジェクト名が terimukuri_ で始まるコンテナだけを停止する
$filterArgs = @()
foreach ($port in 80, 443, 1080, 8080) {
    $filterArgs += "--filter"
    $filterArgs += "publish=$port"
}
$filterArgs += "--filter"
$filterArgs += "name=terimukuri_"

$ids = docker ps @filterArgs -q

if ($ids) {
    docker stop $ids
}
