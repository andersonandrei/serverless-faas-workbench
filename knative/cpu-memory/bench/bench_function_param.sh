#!/bin/bash
set -ueo pipefail
set +x
CONFIGMAPS=('~/serverless-powerapi/knative/configmap-100-50-200.yaml' '~/serverless-powerapi/knative/configmap-100-70-200.yaml' '~/serverless-powerapi/knative/configmap-100-100-200.yaml')
NB_REPEAT=1

CHAMELEON_PARAMETER_ROWS=(10 500 1000 2000)
CHAMELEON_PARAMETER_COLUMNS=(10 500 1000 2000)
CHAMELEON_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_rows,parameter_columns,function_execution,iteration"
function chameleon {
  for nb_rows in "${CHAMELEON_PARAMETER_ROWS[@]}"; do
    for nb_cols in "${CHAMELEON_PARAMETER_COLUMNS[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
        echo "$i: Triggers chameleon with rows = $nb_rows and cols = $nb_cols"
        FUNCTION_EXECUTION="$(curl -s http://chameleon.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{\"num_of_rows\": $nb_rows, \"num_of_cols\": $nb_cols}" | yq '.latencies.function_execution' || echo '-1.0')"
        echo "chameleon,$1,$2,$3,$nb_rows,$nb_cols,$FUNCTION_EXECUTION,$i" >> chameleon_results.csv
      done
      echo ""
    done
    echo ""
  done
  echo ""
}

FLOATOPERATION_PARAMETER_N=(1000000 10000000 100000000 500000000)
FLOATOPERATION_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_n,function_execution,iteration"
function floatoperation {
  for n in "${FLOATOPERATION_PARAMETER_N[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers floatoperation with n = $n"
      FUNCTION_EXECUTION="$(curl -s http://floatoperation.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{\"n\": $n}" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "floatoperation,$1,$2,$3,$n,$FUNCTION_EXECUTION,$i" >> floatoperation_results.csv
    done
    echo ""
  done
  echo ""
}

LINPACK_PARAMETER_N=(100 1000 2000 4000 6000)
LINPACK_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_n,function_execution,iteration"
function linpack {
  for n in "${LINPACK_PARAMETER_N[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers linpack with n = $n"
      FUNCTION_EXECUTION="$(curl -s http://linpack.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{\"n\": $n}" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "linpack,$1,$2,$3,$n,$FUNCTION_EXECUTION,$i" >> linpack_results.csv
    done
    echo ""
  done
  echo ""
}

MATMUL_PARAMETER_N=(100 1000 2000 4000 6000)
MATMUL_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_n,function_execution,iteration"
function matmul {
  for n in "${MATMUL_PARAMETER_N[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers matmul with n = $n"
      FUNCTION_EXECUTION="$(curl -s http://matmul.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{\"n\": $n}" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "matmul,$1,$2,$3,$n,$FUNCTION_EXECUTION,$i" >> matmul_results.csv
    done
    echo ""
  done
  echo ""
}

PYAES_PARAMETER_LENGTHS=(100 1000 10000 25000)
PYAES_PARAMETER_NITER=(10 100 1000)
PYAES_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_length,parameter_niter,function_execution,iteration"
function pyaes {
  for length in "${PYAES_PARAMETER_LENGTHS[@]}"; do
    for niter in "${PYAES_PARAMETER_NITER[@]}"; do
        for ((i = 0 ; i < $NB_REPEAT ; i++)); do
          echo "$i: Triggers pyaes with length = $length and niter = $niter"
          FUNCTION_EXECUTION="$(curl -s http://pyaes.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{\"length_of_message\": $length, \"num_of_iterations\": $niter}" | yq '.latencies.function_execution' || echo '-1.0')"
          echo "pyaes,$1,$2,$3,$length,$niter,$FUNCTION_EXECUTION,$i" >> pyaes_results.csv
      done
      echo ""
    done
    echo ""
  done
  echo ""
}

IMAGEPROCESSING_PARAMETER_IMAGES=("animal-dog.jpg" "SampleImage_20mb.jpg" "SampleImage_40mb.jpg" "SampleImage_50mb.jpg" "SampleImage_60mb.jpg")
IMAGEPROCESSING_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_image,function_execution,iteration"
function imageprocessing {
  for image in "${IMAGEPROCESSING_PARAMETER_IMAGES[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers imageprocessing with image = $image"
      FUNCTION_EXECUTION="$(curl -s http://imageprocessing.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{\"object_key\": \"$image\", \"input_bucket\": \"input\", \"output_bucket\": \"output\", \"endpoint_url\": \"http://minio-service.default:9000\",  \"aws_access_key_id\": \"andrei-access\", \"aws_secret_access_key\": \"andrei-secret\"  }" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "imageprocessing,$1,$2,$3,$image,$FUNCTION_EXECUTION,$i" >> imageprocessing_results.csv
    done
    echo ""
  done
  echo ""
}

FACEDETECTION_PARAMETER_VIDEOS=("big_buck_bunny_720p_30mb.mp4" "SampleVideo_10mb.mp4" "SampleVideo_30mb.mp4" "SampleVideo_50mb.mp4" "SampleVideo_100mb.mp4")
FACEDETECTION_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_video,function_execution,iteration"
function facedetection {
  for video in "${FACEDETECTION_PARAMETER_VIDEOS[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers facedetection with video = $video"
      FUNCTION_EXECUTION="$(curl -s http://facedetection.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{ \"object_key\": \"$video\", \"input_bucket\": \"input\", \"output_bucket\": \"output\", \"model_object_key\": \"haarcascade_frontalface_default.xml\", \"model_bucket\": \"input\", \"endpoint_url\": \"http://minio-service.default:9000\",  \"aws_access_key_id\": \"andrei-access\", \"aws_secret_access_key\": \"andrei-secret\"  }" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "facedetection,$1,$2,$3,$video,$FUNCTION_EXECUTION,$i" >> facedetection_results.csv
    done
    echo ""
  done
  echo ""
}

RNNGENERATE_PARAMETER_TODOPARAM=()
RNNGENERATE_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_todoparam,function_execution,iteration"
function rnngenerate {
  for video in "${RNNGENERATE_PARAMETER_VIDEOS[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers rnngenerate with todoparam = $todoparam"
      FUNCTION_EXECUTION="$(curl -s http://rnngenerate.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{ \"language\": \"Portuguese\", \"start_letters\": \"ABCDEFGHIJKLMNOP\", \"model_parameter_object_key\": \"rnn_params.pkl\", \"model_object_key\": \"rnn_model.pth\", \"model_bucket\": \"input\", \"endpoint_url\": \"http://minio.default:9000\",  \"aws_access_key_id\": \"andrei-access\", \"aws_secret_access_key\": \"andrei-secret\"  }" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "rnngenerate,$1,$2,$3,$todoparam,$FUNCTION_EXECUTION,$i" >> rnngenerate_results.csv
    done
    echo ""
  done
  echo ""
}

MODELTRAINING_PARAMETER_DATASETS=("reviews10mb.csv" "reviews20mb.csv" "reviews50mb.csv" "reviews100mb.csv")
MODELTRAINING_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_dataset,function_execution,iteration"
function modeltraining {
  for dataset in "${MODELTRAINING_PARAMETER_DATASETS[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers modeltraining with dataset = $dataset"
      FUNCTION_EXECUTION="$(curl -s http://modeltraining.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{ \"dataset_object_key\": \"$dataset\", \"dataset_bucket\": \"input\", \"model_object_key\": \"lr_model.pk\", \"model_bucket\": \"input\", \"endpoint_url\": \"http://minio-service.default:9000\",  \"aws_access_key_id\": \"andrei-access\", \"aws_secret_access_key\": \"andrei-secret\"  }" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "modeltraining,$1,$2,$3,$dataset,$FUNCTION_EXECUTION,$i" >> modeltraining_results.csv
    done
    echo ""
  done
  echo ""
}


VIDEOPROCESSING_PARAMETER_VIDEOS=("big_buck_bunny_720p_30mb.mp4" "SampleVideo_10mb.mp4" "SampleVideo_30mb.mp4" "SampleVideo_50mb.mp4" "SampleVideo_100mb.mp4")
VIDEOPROCESSING_CSV_HEADERS="function,concurrency-target-default,concurrency-target-percentage,requests-per-second-target-default,parameter_video,function_execution,iteration"
function videoprocessing {
  for video in "${VIDEOPROCESSING_PARAMETER_VIDEOS[@]}"; do
      for ((i = 0 ; i < $NB_REPEAT ; i++)); do
      echo "$i: Triggers videoprocessing with video = $video"
      FUNCTION_EXECUTION="$(curl -s http://videoprocessing.knative-functions.10.144.8.1.sslip.io -X POST -H 'Content-Type: application/json' -d "{ \"object_key\": \"$video\", \"input_bucket\": \"input\", \"output_bucket\": \"output\", \"model_object_key\": \"haarcascade_frontalface_default.xml\", \"model_bucket\": \"input\", \"endpoint_url\": \"http://minio-service.default:9000\",  \"aws_access_key_id\": \"andrei-access\", \"aws_secret_access_key\": \"andrei-secret\"  }" | yq '.latencies.function_execution' || echo '-1.0')"
      echo "videoprocessing,$1,$2,$3,$video,$FUNCTION_EXECUTION,$i" >> videoprocessing_results.csv
    done
    echo ""
  done
  echo ""
}


function main {
  echo "Using configmap : ${CONFIGMAPS[0]}"
  echo $CHAMELEON_CSV_HEADERS > chameleon_results.csv
  echo $FLOATOPERATION_CSV_HEADERS > floatoperation_results.csv
  echo $LINPACK_CSV_HEADERS > linpack_results.csv
  echo $MATMUL_CSV_HEADERS > matmul_results.csv
  echo $PYAES_CSV_HEADERS > pyaes_results.csv
  echo $IMAGEPROCESSING_CSV_HEADERS > imageprocessing_results.csv
  echo $FACEDETECTION_CSV_HEADERS > facedetection_results.csv
  #echo $RNNGENERATE_CSV_HEADERS > rnngenerate_results.csv
  echo $MODELTRAINING_CSV_HEADERS > modeltraining_results.csv
  echo $VIDEOPROCESSING_CSV_HEADERS > videoprocessing_results.csv
  chameleon 100 50 200
  floatoperation 100 50 200
  linpack 100 50 200
  matmul 100 50 200
  pyaes 100 50 200
  imageprocessing 100 50 200
  facedetection 100 50 200
  #rnngenerate 100 50 200
  modeltraining 100 50 200
  videoprocessing 100 50 200

}

main
