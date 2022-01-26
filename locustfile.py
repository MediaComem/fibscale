from locust import HttpUser, between, task

class FibScale(HttpUser):
    wait_time = between(1, 5)

    @task
    def compute_fibonacci_number(self):
        self.client.post("/", data={"fib": "100", "algorithm": "iterative"})