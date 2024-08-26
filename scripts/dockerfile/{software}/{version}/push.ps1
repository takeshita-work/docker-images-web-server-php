try {
    # 設定ファイルの読み込み
    . $PSScriptRoot/../../__config.ps1  # repository の設定
    . $PSScriptRoot/../__config.ps1        # distribution の設定
    . $PSScriptRoot/__config.ps1           # version の設定

    # タグ の生成
    $imageTagLatest = "${global:repositoryName}:${global:distributionName}${global:version}"
    $imageTagDate   = "${global:repositoryName}:${global:distributionName}${global:version}_${global:date}"

    # 生成値の出力
    echo $imageTagLatest
    echo $imageTagDate

    # プッシュの実行
    docker push $imageTagLatest
    docker push $imageTagDate
} catch {
    echo "Error: $_"
    exit 1
}
