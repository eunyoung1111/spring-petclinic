# 1. 베이스 이미지 설정
# 자바 21 버전의 실행 환경(JRE)이 담긴 초경량 Alpine 리눅스를 사용
# JDK가 아닌 JRE를 사용하여 이미지 크기를 최소화, 보안 강화
FROM eclipse-temurin:21-jre-alpine

# 2. 빌드 시 사용할 변수 정의
# 메이븐 빌드 결과물인 .jar 파일의 위치를 지정
# 파일 이름에 버전이 바뀌어도 대응 = 와일드카드(*)
ARG JAR_FILE=target/spring-petclinic-*.jar 

# 3. 실제 파일을 컨테이너 내부로 복사
# 호스트(서버)에 있는 jar 파일을 컨테이너 내부의 'app.jar'라는 이름으로 가져옴
COPY ${JAR_FILE} app.jar

# 4. 컨테이너 시작 시 실행할 명령
# 컨테이너가 뜨자마자 자바 명령어로 스프링 부트 앱을 실행하도록 설정
ENTRYPOINT ["java","-jar","/app.jar"]
