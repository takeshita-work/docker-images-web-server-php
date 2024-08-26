try {
    # 設定ファイルの読み込み
    . $PSScriptRoot/../../__config.ps1  # repository の設定
    . $PSScriptRoot/../__config.ps1        # distribution の設定
    . $PSScriptRoot/__config.ps1           # version の設定

    # タグ の生成
    $imageTagLatest = "${global:repositoryName}:${global:softwareName}${global:version}"
    $imageTagDate   = "${global:repositoryName}:${global:softwareName}${global:version}_${global:date}"

    # Dockerfile のパスの生成
    $dockerfilePath = "./dockerfile/${global:softwareName}/${global:version}/Dockerfile"

    # 生成値の出力
    echo $imageTagLatest
    echo $imageTagDate
    echo $dockerfilePath

    # ビルドの実行
    docker build --no-cache `
        -f $dockerfilePath `
        -t $imageTagLatest `
        -t $imageTagDate `
        .
} catch {
    echo "Error: $_"
    exit 1
}
